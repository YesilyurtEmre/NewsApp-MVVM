//
//  HomeViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import Foundation
import Alamofire


class HomeViewModel {
    var newsItems: [NewsItem] = []
    var selectedCategory: Categories = .general
    var selectedCategoryIndex: IndexPath?
   
    func fetchNews(completion: @escaping () -> Void) {
        APIServices.shared.fetchNews(category: selectedCategory) { result in
            switch result {
            case .success(let items):
                self.newsItems = items
                print(items)
                completion()
            case .failure(let error):
                print("error-\(error)")
                completion()
            }
        }
    }

    func getCategoriesCount() -> Int {
        return Categories.allCases.count
    }
    
    func getNewsItemsCount() -> Int {
        return newsItems.count
    }
}
