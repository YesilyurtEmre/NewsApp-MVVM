//
//  HomeView.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.12.2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: SwiftUIViewModel
    
    var body: some View {
        VStack() {
            Text("Google News")
                .font(.title2)
                .font(.system(size: 17, weight: .medium))
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .top)
            
            ScrollView(.horizontal) {
                HStack {
                    Spacer(minLength: 20)
                    ForEach(0..<viewModel.getCategoriesCount(), id: \.self) { index in
                        let category = Categories(rawValue: index)
                        let isSelected = category == viewModel.selectedCategory
                        CategoryButton(category: category, isSelected: isSelected) {
                            selectCategory(index: index)
                        }
                    }
                }
                .padding(.horizontal)
            }
            List(viewModel.newsItems) { newsItem in
                NavigationLink(destination: NewsDetailSwiftUI(viewModel: NewsDetailViewModel( news: newsItem, isFavorite: newsItem.isFavorite))) {
                    NewsRow(newsItem: newsItem) {
                        viewModel.toggleFavorite(for: newsItem)
                    }
                }
            }
            .id(UUID())
            .listStyle(.plain)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
    }
    
    
    func selectCategory(index: Int) {
        viewModel.selectedCategoryIndex = index
        viewModel.selectedCategory = Categories(rawValue: index)!
        viewModel.fetchNews()
    }
    
    struct CategoryButton: View {
        var category: Categories?
        var isSelected: Bool
        var action: () -> Void
        
        var body: some View {
            Text(category?.title ?? "")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background(isSelected ? .white : .gray)
                .foregroundColor(isSelected ? .black : .white)
                .cornerRadius(8)
                .onTapGesture {
                    action()
                }
        }
    }
    
    struct NewsRow: View {
        @State  var newsItem: NewsItem
        @State private var favImage: UIImage?
        var toggleFavorite: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    if let imageUrl = URL(string: newsItem.image) {
                        AsyncImage(url: imageUrl) { image in
                            image.resizable()
                                .cornerRadius(8)
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Button(action: {
                        favImageTapped()
                        
                    }) {
                        Image(newsItem.isFavorite ? "SelectedFavorite" : "NonselectedFavorite")
                            .resizable()
                            .frame(width: 12, height: 24)
                            .foregroundColor(newsItem.isFavorite ? .black : .white)
                            .padding(8)
                            .onTapGesture {
                                favImageTapped()
                            }
                    }
                }
                
                Text(newsItem.source)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(newsItem.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(newsItem.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        
        private func favImageTapped() {
            if newsItem.isFavorite {
                newsItem.isFavorite = false
                FavoriteNewsManager.shared.removeFavorite(newsID: newsItem.id.uuidString) { error in
                    if let error = error {
                        print("Error removing favorite: \(error)")
                    } else {
                        print("Favori olarak kaldırıldı: \(newsItem.name)")
                    }
                }
            }
            else {
                newsItem.isFavorite = true
                newsItem.userEmail = AuthManager.shared.currentUser?.email
                FavoriteNewsManager.shared.addFavorite(news: newsItem) { error in
                    if let error = error {
                        print("Error adding favorite: \(error)")
                    } else {
                        print("Favori olarak eklendi: \(newsItem.name)")
                    }
                }
            }
        }
        
        
        private func updateFavImage() {
            let imageName = newsItem.isFavorite ? "SelectedFavorite" : "NonSelectedFavorite"
            favImage = UIImage(named: imageName)
        }
    }
}

#Preview {
    HomeView(viewModel: SwiftUIViewModel())
}
