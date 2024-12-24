//
//  NewsModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import Foundation

struct NewsResponse: Codable {
    let success: Bool
    let result: [NewsItem]
}

struct NewsItem: Identifiable, Codable {
    var id = UUID()
//    let key: String
    let url: String
    let description: String
    let image: String
    var name: String
    let source: String
    var isFavorite: Bool = false
    var userEmail: String?
    
    
    enum CodingKeys: String, CodingKey {
        case /*key,*/ url, description, image, name, source
    }
}

