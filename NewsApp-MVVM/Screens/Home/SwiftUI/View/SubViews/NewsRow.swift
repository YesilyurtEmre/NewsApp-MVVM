//
//  NewsRow.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 23.12.2024.
//

import SwiftUI

struct NewsRow: View {
    @State  var newsItem: NewsItem
    @State private var favImage: UIImage?
    @State private var image: UIImage?
    var toggleFavorite: (() -> Void)?
    var showFavoriteButton: Bool = true
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                
                if let imageUrl = URL(string: newsItem.image) {
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 343, height: 200)
                        .clipped()
                        .cornerRadius(10)
                        .onAppear {
                            loadImage(from: imageUrl)
                        }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 343, height: 200)
                        .clipped()
                }
                
                if showFavoriteButton {
                    Button(action: {
                        favImageTapped()
                        
                    }) {
                        Image(newsItem.isFavorite ? "SelectedFavorite" : "NonselectedFavorite")
                            .resizable()
                            .frame(width: 15, height: 30)
                            .foregroundColor(newsItem.isFavorite ? .black : .white)
                            .padding(8)
                            .onTapGesture {
                                favImageTapped()
                            }
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
        }
    }
    
    private func loadImage(from url: URL) {
        UIImageView().af.setImage(withURL: url, completion:  { response in
            if let image = response.value {
                self.image = image
            } else if let error = response.error {
                print("Error loading image: \(error.localizedDescription)")
            }
        })
        
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
        updateFavImage()
    }
    
    
    private func updateFavImage() {
        let imageName = newsItem.isFavorite ? "SelectedFavorite" : "NonSelectedFavorite"
        favImage = UIImage(named: imageName)
    }
}
