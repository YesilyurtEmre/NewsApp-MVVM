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
    
    func getCategoriesCount() -> Int {
        return Categories.allCases.count
    }
    
    func getNewsItemsCount() -> Int {
        return newsItems.count
    }
}
