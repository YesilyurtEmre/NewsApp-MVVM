//
//  HomeViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import Foundation
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
                self.newsItems = items
                self.delegate?.reloadData()
            case .failure(let error):
                print("error-\(error)")
            }
            completion()
        }
    }
    
    func handleFavoriteButtonTapped(at indexPath: IndexPath, isFavorite: Bool) {
        let newsItem = newsItems[indexPath.row]
        
        if !isFavorite {
            FavoriteNewsManager.shared.removeFavorite(newsID: newsItem.id.uuidString) { error in
                if let error = error {
                    print("Error removing favorite: \(error.localizedDescription)")
                } else {
                    print("Favorite removed successfully")
                    self.removeFavorite(news: newsItem)
                    self.delegate?.reloadData()
                }
            }
        } else {
            FavoriteNewsManager.shared.addFavorite(news: newsItem) { error in
                if let error = error {
                    print("Error adding favorite: \(error.localizedDescription)")
                } else {
                    print("Favorite added successfully")
                    self.addFavorite(news: newsItem)
                    self.delegate?.reloadData()
                }
            }
        }
    }
    
    
    func getCategoriesCount() -> Int {
        return Categories.allCases.count
    }
    
    func getNewsItemsCount() -> Int {
        return newsItems.count
    }
    
    func isFavorite(news: NewsItem) -> Bool {
        return favoriteNews.contains { $0.id == news.id }
    }
    
    func addFavorite(news: NewsItem) {
        if !isFavorite(news: news) {
            favoriteNews.append(news)
        }
    }
    
    func removeFavorite(news: NewsItem) {
        favoriteNews.removeAll { $0.id == news.id }
    }
}
