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
    private let collectionName = "FavoriteNews"
    
    private init() {}
    
    // MARK: - Add Favorite News
    func addFavorite(news: NewsItem, completion: @escaping (Error?) -> Void) {
        let docData: [String: String] = [
            "id": news.id.uuidString,
            "key": news.key,
            "url": news.url,
            "description": news.description,
            "image": news.image,
            "name": news.name,
            "source": news.source,
            "userId": news.userId ?? ""
        ]
        
        db.collection(collectionName).document(news.id.uuidString).setData(docData) { error in
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
    func loadFavorites(for userId: String, completion: @escaping ([NewsItem]?, Error?) -> Void) {
        db.collection(collectionName).whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion(nil, error)
                return
            }
            var newsItems: [NewsItem] = []
            for document in documents {
                do {
                    let newsItem = try document.data(as: NewsItem.self)
                    newsItems.append(newsItem)
                } catch {
                    print("Error decoding document: \(error)")
                    completion(nil, error)
                    return
                }
            }
            completion(newsItems, nil)
        }
    }

}
