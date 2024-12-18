//
//  HomeViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import UIKit
import Alamofire

protocol HomeViewModelProtocol: AnyObject {
    func reloadData()
}

final class HomeViewModel {
    var newsItems: [NewsItem] = []
    var selectedCategory: Categories = .general
    var selectedCategoryIndex: IndexPath?
    var selectedNewsItem: NewsItem?
    
    private var favoriteNews: [NewsItem] = []
    weak var delegate: HomeViewModelProtocol?
    
    init() {
        fetchNews()
    }
    
    func selectNewsItem(at indexPath: IndexPath) {
        selectedNewsItem = newsItems[indexPath.row]
    }
    
    func registerCells(for collectionView: UICollectionView, and tableView: UITableView) {
        let categoryNib = UINib(nibName: Constants.CellIdentifiers.categoryCell, bundle: nil)
        collectionView.register(categoryNib, forCellWithReuseIdentifier: Constants.CellIdentifiers.categoryCell)
        
        let newsNib = UINib(nibName: Constants.CellIdentifiers.newsCell, bundle: nil)
        tableView.register(newsNib, forCellReuseIdentifier: Constants.CellIdentifiers.newsCell)
        
    }
    
    func fetchNews() {
        APIServices.shared.fetchNews(category: selectedCategory) { result in
            switch result {
            case .success(let items):
                FavoriteNewsManager.shared.loadFavorites(for: AuthManager.shared.currentUser?.email ?? "") { favoriteNews, error in
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
        }
    }
    
//    func updateFavoriteStatus(for newsItem: NewsItem) {
//        if let index = newsItems.firstIndex(where: { $0.id == newsItem.id }) {
//            newsItems[index].isFavorite = newsItem.isFavorite
//        }
//    }
    
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
