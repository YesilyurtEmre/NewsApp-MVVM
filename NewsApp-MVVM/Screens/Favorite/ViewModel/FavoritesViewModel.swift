//
//  FavoritesViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 26.10.2024.
//

import Foundation
import FirebaseAuth

final class FavoritesViewModel {
    
    init() {
        loadFavorites()
    }
    
    var favoriteNews: [NewsItem] = [] {
        didSet {
            print("Favorites updated, new count: \(favoriteNews.count)")
            onFavoritesUpdated?()
        }
    }
    
    var onFavoritesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func loadFavorites() {
        FavoriteNewsManager.shared.loadFavorites(for: AuthManager.shared.currentUser?.email ?? "") { [weak self] favoriteNews, error in
            guard let favoriteNews = favoriteNews else { return }
            let updatedItems = favoriteNews.map { item -> NewsItem in
                var updatedItem = item
                updatedItem.isFavorite = true
                return updatedItem
            }
            self?.favoriteNews = updatedItems
        }
    }
    
    func updateFavoriteStatus(for newsItem: NewsItem) {
        if let index = favoriteNews.firstIndex(where: { $0.id == newsItem.id }) {
            favoriteNews[index].isFavorite = newsItem.isFavorite
            
            if !newsItem.isFavorite {
                FavoriteNewsManager.shared.removeFavorite(newsName: newsItem.name) { [weak self] error in
                    if let error = error {
                        print("Error removing favorite: \(error)")
                        self?.onError?(error)
                    }else {
                        self?.onFavoritesUpdated?()
                    }
                }
            }
        }
    }
}
