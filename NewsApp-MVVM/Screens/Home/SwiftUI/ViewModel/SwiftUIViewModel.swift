//
//  SwiftUIViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.12.2024.
//


import SwiftUI
import Combine
import FirebaseAuth

final class SwiftUIViewModel: ObservableObject {
    
    @Published var selectedCategoryIndex: Int?
    @Published var newsItems: [NewsItem] = []
    @Published var selectedCategory: Categories = .general
    @Published var selectedNewsItem: NewsItem?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchNews()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoriteStatusChanged(_:)),
            name: .favoriteStatusChanged,
            object: nil
        )
    }
    
    @objc private func handleFavoriteStatusChanged(_ notification: Notification) {
        if let updatedItem = notification.userInfo?["newsItem"] as? NewsItem,
           let index = newsItems.firstIndex(where: { $0.name == updatedItem.name }) {
            newsItems[index] = updatedItem
            
        }
    }
    
    func fetchNews() {
        APIServices.shared.fetchNews(category: selectedCategory) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newsItems):
                guard let userEmail = Auth.auth().currentUser?.email else {
                    print("User email not found")
                    return
                }
                
                FavoriteNewsManager.shared.loadFavorites(for: userEmail) { favoriteNews, error in
                    guard let favoriteNews = favoriteNews else {
                        if let error = error {
                            print("Error loading favorites: \(error.localizedDescription)")
                        }
                        return
                    }
                    
                    let favoriteNewsNames = Set(favoriteNews.compactMap { $0.name })
                    let updatedNewsItems = newsItems.map { item -> NewsItem in
                        var updatedNewsItem = item
                        if favoriteNewsNames.contains(item.name) {
                            updatedNewsItem.isFavorite = true
                        } else {
                            updatedNewsItem.isFavorite = false
                        }
                        
                        return updatedNewsItem
                    }
                    
                    DispatchQueue.main.async {
                        self.newsItems = updatedNewsItems
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching news: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func toggleFavorite(for newsItem: NewsItem) {
        if let index = newsItems.firstIndex(where: { $0.id == newsItem.id }) {
            newsItems[index].isFavorite.toggle()
            
            if newsItems[index].isFavorite {
                FavoriteNewsManager.shared.addFavorite(news: newsItems[index]) { error in
                    if let error = error {
                        print("Error adding favorite: \(error.localizedDescription)")
                        self.newsItems[index].isFavorite = false
                    }
                }
            } else {
                FavoriteNewsManager.shared.removeFavorite(newsID: newsItems[index].id.uuidString) { error in
                    if let error = error {
                        print("Error removing favorite: \(error.localizedDescription)")
                        self.newsItems[index].isFavorite = true
                    }
                }
            }
        }
    }
    
    func selectNewsItem(at indexPath: IndexPath) {
        guard indexPath.row < newsItems.count else { return }
        selectedNewsItem = newsItems[indexPath.row]
    }
    
    func getCategoriesCount() -> Int {
        Categories.allCases.count
    }
    
    func getNewsItemsCount() -> Int {
        newsItems.count
    }
    
    func getNewsItem(at index: Int) -> NewsItem {
        return newsItems[index]
    }
}

