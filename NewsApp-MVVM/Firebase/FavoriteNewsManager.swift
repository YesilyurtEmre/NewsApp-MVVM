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
    
    // MARK: - Add User to Firestore and Initialize Data
    func addUserToFirestore(completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Current user not found"]))
            return
        }
        
        let userDocData: [String: Any] = [
            "email": currentUser.email ?? ""
        ]
        
        db.collection(collectionName).document(currentUser.email ?? "").setData(userDocData) { error in
            if let error = error {
                print("Kullanıcı Firestore'a kaydedilemedi: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Kullanıcı Firestore'a başarıyla kaydedildi!")
                
                self.createFavoritesCollection(email: currentUser.email ?? "")
                completion(nil)
            }
        }
    }
    
    // MARK: - Create Favorites Collection for New User
    func createFavoritesCollection(email: String) {
        let favoritesDoc = db.collection(collectionName)
            .document(email)
            .collection("favorites")
            .document()
        
        let defaultData: [String: Any] = [
            "url": "",
            "description": "",
            "image": "",
            "name": "initialized",
            "source": "",
            "email": email
        ]
        
        favoritesDoc.setData(defaultData) { error in
            if let error = error {
                print("Error initializing favorites collection: \(error)")
            } else {
                print("Favorites collection initialized for \(email)")
            }
        }
    }
    
    // MARK: - Add Favorite News
    func addFavorite(news: NewsItem, completion: @escaping (Error?) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email, !userEmail.isEmpty else {
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
        
        db.collection(collectionName)
            .document(userEmail)
            .collection("favorites")
            .document(news.name)
            .setData(docData) { error in
                if error == nil {
                    self.favorites.append(news)
                    NotificationCenter.default.post(name: .favoriteNewsUpdated, object: nil)
                }
                completion(error)
            }
    }
    
    
    // MARK: - Remove Favorite News
    func removeFavorite(newsName: String, completion: @escaping (Error?) -> Void) {
        db.collection(collectionName).document(Auth.auth().currentUser?.email ?? "").collection("favorites").document(newsName).delete { error in
            if let error = error {
            } else {
                self.favorites.removeAll { $0.name == newsName }
                NotificationCenter.default.post(name: .favoriteNewsUpdated, object: nil)
            }
            completion(error)
        }
    }
    
    
    // MARK: - Load Favorite News
    func loadFavorites(for email: String, completion: @escaping ([NewsItem]?, Error?) -> Void) {
        guard !email.isEmpty else {
            let errorMessage = "User email is empty"
            print(errorMessage)
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
            return
        }
        
        db.collection(collectionName)
            .document(email)
            .collection("favorites")
            .getDocuments { snapshot, error in
                
                guard let documents = snapshot?.documents else {
                    let errorMessage = error?.localizedDescription ?? "Unknown error while fetching documents"
                    print("\(Constants.Errors.firestoreError) \(errorMessage)")
                    completion(nil, error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                    return
                }
                
                var newsItems: [NewsItem] = []
                for document in documents {
                    let data = document.data()
                    do {
                        let newsItem = try document.data(as: NewsItem.self)
                        newsItems.append(newsItem)
                    } catch {
                    }
                }
                self.favorites = newsItems
                print("Favorites loaded successfully for user: \(email)")
                completion(newsItems, nil)
            }
    }
}
