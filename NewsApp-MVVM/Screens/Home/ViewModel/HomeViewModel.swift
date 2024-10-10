//
//  HomeViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import Foundation

class HomeViewModel {
    var newsItems: [NewsItem] = []
    
    func fetchNews() { // API CAĞRISI TAMAMLANDIĞINDA UI YI GÜNCELLEYEMEYEBİLİRİM COMPLETION HANDLER KULLANMAZSAM
        APIServices.shared.fetchNews { result in
            switch result {
            case .success(let items):
                self.newsItems = items
                print(items)
//                completion(.success(items))
            case .failure(let error):
//                completion(.failure(error))
                print("error-\(error)")
            }
        }
    }
}
