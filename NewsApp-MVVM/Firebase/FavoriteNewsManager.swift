//
//  FavoriteNewsManager.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 21.10.2024.
//

import FirebaseFirestore
import UIKit
import FirebaseAuth

class FavoriteNewsManager {
    static let shared = FavoriteNewsManager()
    private let db = Firestore.firestore()
    private let collectionName = Constants.FirestoreKeys.collectionName
    
    private(set) var favorites: [NewsItem] = []
    
    private init() {}
    
    // MARK: - Add Favorite News
    func addFavorite(news: NewsItem, completion: @escaping (Error?) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            print("Kullanıcı e-postası alınamadı.")
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User email not found"]))
            return
        }
        let docData: [String: String] = [
            Constants.FirestoreKeys.id: news.id.uuidString,
            Constants.FirestoreKeys.key: news.key,
            Constants.FirestoreKeys.url: news.url,
            Constants.FirestoreKeys.description: news.description,
            Constants.FirestoreKeys.image: news.image,
            Constants.FirestoreKeys.name: news.name,
            Constants.FirestoreKeys.source: news.source,
            Constants.FirestoreKeys.email: userEmail
        ]
        db.collection(collectionName).document(news.id.uuidString).setData(docData) { error in
            if error == nil {
                self.favorites.append(news)
                NotificationCenter.default.post(name: .favoriteNewsUpdated, object: nil)
            }
            completion(error)
        }
    }
    
    // MARK: - Remove Favorite News
    func removeFavorite(newsID: String, completion: @escaping (Error?) -> Void) {
        db.collection(collectionName).document(newsID).delete { error in
            if error == nil {
                self.favorites.removeAll { $0.id.uuidString == newsID }
                NotificationCenter.default.post(name: .favoriteNewsUpdated, object: nil)
            }
            completion(error)
        }
        
    }
    
    // MARK: - Load Favorite News
    func loadFavorites(for email: String, completion: @escaping ([NewsItem]?, Error?) -> Void) {
        db.collection(collectionName).whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                
                let errorMessage = error?.localizedDescription ?? "Unknown error while fetching documents"
                print("\(Constants.Errors.firestoreError) \(errorMessage)")
                
                completion(nil, error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                return
            }
            
            var newsItems: [NewsItem] = []
            for document in documents {
                do {
                    var newsItem = try document.data(as: NewsItem.self)
                    if let uuid = UUID(uuidString: document.documentID) {
                        newsItem.id = uuid
                    } else {
                        print("\(Constants.Errors.invalidUUID) \(document.documentID)")
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid UUID: \(document.documentID)"]))
                        return
                    }
                    newsItems.append(newsItem)
                } catch {
                    print("\(Constants.Errors.decodingError) \(error)")
                    completion(nil, error)
                    return
                }
            }
            self.favorites = newsItems
            print("Favorites loaded successfully for user: \(email)")
            completion(newsItems, nil)
        }
    }
}
