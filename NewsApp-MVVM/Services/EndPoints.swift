//
//  EndPoints.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import Foundation

enum EndPoints {
    static let BASE_URL = "https://api.collectapi.com/news/getNews?country=tr"
    static let API_KEY = "apikey 0kCv4LjInzQXnTjyjBXxU9:7ewzB8cMN5OA40ZVrHXNR3"
    
    case getNews(String)
    
    var stringValue: String {
        switch self {
        case .getNews(let tag):
            return EndPoints.BASE_URL + "&tag=\(tag)"
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
    
}
