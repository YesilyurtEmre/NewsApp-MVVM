//
//  HomeViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import FirebaseFirestore
import UIKit
import Alamofire

protocol HomeViewModelProtocol: AnyObject {
    func reloadData()
}

class HomeViewModel {
    var newsItems: [NewsItem] = []
    var news: NewsItem?
    var selectedCategory: Categories = .general
    var selectedCategoryIndex: IndexPath?
    var selectedNewsItem: NewsItem?
    var newsItem : [NewsItem] = []
    
    private var favoriteNews: [NewsItem] = []
    weak var delegate: HomeViewModelProtocol?
    
    init() {
        fetchNews {
            print("data fetched")
        }
    }
    struct CellIdentifiers {
        static let newsCell = "NewsCell"
        static let categoryCell = "CategoryCell"
    }
    
    
    func selectNewsItem(at indexPath: IndexPath) {
        selectedNewsItem = newsItems[indexPath.row]
    }
    
    func registerCells(for collectionView: UICollectionView, and tableView: UITableView) {
        let categoryNib = UINib(nibName: "CategoryCell", bundle: nil)
        collectionView.register(categoryNib, forCellWithReuseIdentifier: CellIdentifiers.categoryCell)
        
        let newsNib = UINib(nibName: "NewsCell", bundle: nil)
        tableView.register(newsNib, forCellReuseIdentifier: CellIdentifiers.newsCell)
        
    }
    
    func fetchNews(completion: @escaping () -> Void) {
        APIServices.shared.fetchNews(category: selectedCategory) { result in
            switch result {
            case .success(let items):
                FavoriteNewsManager.shared.loadFavorites { favoriteNews, error in
                    guard let favoriteNews = favoriteNews else { return }
                    let favoriteNamesSet = Set(favoriteNews.compactMap { $0.name })
                    
                    let updatedItems = items.map { item -> NewsItem in
                        var updatedItem = item
                        if favoriteNamesSet.contains(item.name) {
                            updatedItem.isFavorite = true
                        } else {
                            updatedItem.isFavorite = false
                        }
                        return updatedItem
                    }
                    self.newsItems = updatedItems
                    self.delegate?.reloadData()
                }
            case .failure(let error):
                print("error-\(error)")
            }
            completion()
        }
    }
    
    func updateFavoriteStatus(for newsItem: NewsItem) {
        if let index = newsItems.firstIndex(where: { $0.id == newsItem.id }) {
            newsItems[index].isFavorite = newsItem.isFavorite
        }
    }
    
    func loadFavorites() {
        FavoriteNewsManager.shared.loadFavorites { [weak self] favorites, error in
            guard let self = self, error == nil else {
                print("Error loading favorites: \(String(describing: error))")
                return
            }
            self.favoriteNews = favorites ?? []
            self.delegate?.reloadData()
        }
    }
    
    func isFavorite(news: NewsItem) -> Bool {
        return favoriteNews.contains(where: { $0.id == news.id })
    }
    
    func toggleFavorite(news: NewsItem) {
        if isFavorite(news: news) {
            removeFavorite(news)
        } else {
            addFavorite(news)
        }
    }
    
    private func addFavorite(_ news: NewsItem) {
        FavoriteNewsManager.shared.addFavorite(news: news) { [weak self] error in
            if let error = error {
                print("Error adding favorite: \(error)")
            } else {
                self?.favoriteNews.append(news)
                self?.delegate?.reloadData()
            }
        }
    }
    
    private func removeFavorite(_ news: NewsItem) {
        FavoriteNewsManager.shared.removeFavorite(newsID: news.id.uuidString) { [weak self] error in
            if let error = error {
                print("Error removing favorite: \(error)")
            } else {
                self?.favoriteNews.removeAll(where: { $0.id == news.id })
                self?.delegate?.reloadData()
            }
        }
    }
    
    
    func getCategoriesCount() -> Int {
        Categories.allCases.count
    }
    
    func getNewsItemsCount() -> Int {
        newsItems.count
    }
    
    func getNewsItem(at indexPath: IndexPath) -> NewsItem {
        return newsItems[indexPath.row]
    }
}
