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
                FavoriteNewsManager.shared.loadFavorites(for: AuthManager.shared.currentUser?.email ?? "") { favoriteNews, error in
                    guard let favoriteNews = favoriteNews else { return }
                    let favoriteNamesSet = Set(favoriteNews.compactMap { $0.name })
                    self.searchedNews = newsResponse.map { item -> NewsItem in
                        var updatedItem = item
                        updatedItem.isFavorite = favoriteNamesSet.contains(item.name)
                        return updatedItem
                    }
                    self.delegate?.loadNews()
                }
            case .failure(let error):
                print("Fetch error \(error)")
            }
        }
    }
    
    func searchNews(searchText: String) {
        if searchText.isEmpty {
            filteredNews = []
        } else {
            let favoriteNamesSet = Set(FavoriteNewsManager.shared.favorites.compactMap { $0.name })
            filteredNews = searchedNews.filter { $0.name.lowercased().contains(searchText.lowercased()) }.map { item -> NewsItem in
                var updatedItem = item
                updatedItem.isFavorite = favoriteNamesSet.contains(item.name)
                return updatedItem
            }
        }
        delegate?.loadNews()
    }
    
    func filteredNewsCount() -> Int {
        filteredNews.count
    }
}
