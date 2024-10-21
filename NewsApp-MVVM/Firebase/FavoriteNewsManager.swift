//
//  FavoriteNewsManager.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 21.10.2024.
//

import FirebaseFirestore
import UIKit

class FavoriteNewsManager {
    static let shared = FavoriteNewsManager()
    private let db = Firestore.firestore()
    private let collectionName = "FavoritesNews"
    
    private init() {}
    
    // MARK: - Add Favorite News
    func addFavorite(news: NewsItem, completion: @escaping (Error?) -> Void) {
        do {
            let data = try news.toDictionary()
            db.collection(collectionName).document(news.id.uuidString).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    // MARK: - Remove Favorite News
    func removeFavorite(newsID: String, completion: @escaping (Error?) -> Void) {
        db.collection(collectionName).document(newsID).delete { error in
            completion(error)
        }
    }
    
    // MARK: - Load Favorite News
    func loadFavorites(completion: @escaping ([NewsItem]?, Error?) -> Void) {
        db.collection(collectionName).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion(nil, error)
                return
            }
            
            let favorites = documents.compactMap { doc -> NewsItem? in
                return NewsItem.fromDictionary(doc.data())
            }
            completion(favorites, nil)
        }
    }
}
