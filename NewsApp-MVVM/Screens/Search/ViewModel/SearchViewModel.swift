//
//  SearchViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 15.10.2024.
//

import UIKit

protocol SearchViewModelProtocol: AnyObject {
    func loadNews()
}

final class SearchViewModel {
    
    var filteredNews: [NewsItem] = []
    var searchedNews: [NewsItem] = []
    
    var isSearching = false
    
    weak var delegate: SearchViewModelProtocol?
    
    init() {
        fetchInitialNews()
    }
    
    func fetchInitialNews() {
        APIServices.shared.fetchNews(category: Categories.general) { result in
            switch result {
            case .success(let newsResponse):
                self.searchedNews = newsResponse
            case .failure(let error):
                print("Fetch error \(error)")
            }
            
        }
    }
    
    func searchNews(searchText: String) {
        if searchText.isEmpty {
            filteredNews = []
        } else {
            filteredNews = searchedNews.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        delegate?.loadNews()
    }
    
    func filteredNewsCount() -> Int {
        filteredNews.count
    }
    
}
