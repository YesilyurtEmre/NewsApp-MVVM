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
    
    // Convert Dictionary to NewsItem
    static func fromDictionary(_ dict: [String: Any]) -> NewsItem? {
        do {
            var data = dict
            if let idString = dict["id"] as? String {
                data["id"] = UUID(uuidString: idString) // Convert String back to UUID
            }
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            return try JSONDecoder().decode(NewsItem.self, from: jsonData)
        } catch {
            print("Error decoding NewsItem: \(error)")
            return nil
        }
    }
}

