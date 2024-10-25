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

struct NewsItem: Codable {
    var id = UUID()
    let key: String
    let url: String
    let description: String
    let image: String
    let name: String
    let source: String
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case key, url, description, image, name, source
    }
    
    // Convert NewsItem to Dictionary
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        var dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        dictionary["id"] = id.uuidString // Store UUID as String
        return dictionary
    }
}

