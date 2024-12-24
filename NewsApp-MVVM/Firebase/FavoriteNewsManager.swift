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
    
    func addUserToFirestore(completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("Mevcut kullanıcı bulunamadı.")
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Current user not found"]))
            return
        }
        
        let userDocData: [String: Any] = [
            "email": currentUser.email ?? ""
        ]
        
        db.collection("users").document(currentUser.email ?? "").setData(userDocData) { error in
            if let error = error {
                print("Kullanıcı Firestore'a kaydedilemedi: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Kullanıcı Firestore'a başarıyla kaydedildi!")
                completion(nil)
            }
        }
    }
    
    // MARK: - Add Favorite News
    func addFavorite(news: NewsItem, completion: @escaping (Error?) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            print("Kullanıcı e-postası alınamadı.")
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User email not found"]))
            return
        }
        
        let docData: [String: String] = [
            Constants.FirestoreKeys.id: news.id.uuidString,
            Constants.FirestoreKeys.url: news.url,
            Constants.FirestoreKeys.description: news.description,
            Constants.FirestoreKeys.image: news.image,
            Constants.FirestoreKeys.name: news.name,
            Constants.FirestoreKeys.source: news.source,
            Constants.FirestoreKeys.email: userEmail
        ]
        db.collection(collectionName).document(news.userEmail ?? "").setData(docData) { error in
            if error == nil {
                self.favorites.append(news)
                NotificationCenter.default.post(name: .favoriteNewsUpdated, object: nil)
            }
            completion(error)
        }
    }
    
    // MARK: - Remove Favorite News
    func removeFavorite(newsName: String, completion: @escaping (Error?) -> Void) {
        db.collection(collectionName).document(newsName).delete { error in
            if error == nil {
                self.favorites.removeAll { $0.name == newsName }
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
                    newsItem.name = document.documentID
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
