//
//  SwiftUIViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.12.2024.
//

import SwiftUI
import Combine
import Alamofire

final class SwiftUIViewModel: ObservableObject {
    
    @Published var selectedCategoryIndex: Int?
    @Published var newsItems: [NewsItem] = []
    @Published var selectedCategory: Categories = .general
    @Published var selectedNewsItem: NewsItem?
    @Published private var favoriteNews: [NewsItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchNews()
    }
    
    func fetchNews() {
        APIServices.shared.fetchNews(category: selectedCategory) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                FavoriteNewsManager.shared.loadFavorites(for: AuthManager.shared.currentUser?.email ?? "") { favoriteNews, error in
                    guard let favoriteNews = favoriteNews else { return }
                    
                    let favoriteNamesSet = Set(favoriteNews.compactMap { $0.name })
                    let updatedItems = items.map { item -> NewsItem in
                        var updatedItem = item
                        updatedItem.isFavorite = favoriteNamesSet.contains(item.name)
                        return updatedItem
                    }
                    
                    DispatchQueue.main.async {
                        self.newsItems = updatedItems
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("error-\(error)")
                }
            }
        }
    }
    
    func updateFavoriteStatus(for newsItem: NewsItem) {
        if let index = newsItems.firstIndex(where: { $0.id == newsItem.id }) {
            newsItems[index].isFavorite = newsItem.isFavorite
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

