//
//  FavoritesViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 26.10.2024.
//

import Foundation

class FavoritesViewModel {
    var favoriteNews: [NewsItem] = [] {
        didSet {
            onFavoritesUpdated?()
        }
    }
    var onFavoritesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func loadFavorites(for userId: String) {
        FavoriteNewsManager.shared.loadFavorites(for: userId) { [weak self] newsItems, error in
            if let error = error {
                self?.onError?(error)
                return
            }
            self?.favoriteNews = newsItems ?? []
        }
    }
}
