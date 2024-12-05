//
//  EndPoints.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import Foundation
import Moya


enum NewsService {
    case fetchNews(category: Categories)
    static let BASE_URL = "https://api.collectapi.com/news/getNews"
    static let API_KEY = "apikey 5siN5NH6M8e5O8G4rEGoRl:6w9z9SY0dbVu4dzisAcZnt"
}

extension NewsService: TargetType {
    var path: String {
        switch self {
        case .fetchNews:
            return "/getNews"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchNews(let category):
            return .requestParameters(parameters: ["country": "tr", "tag": category.tag], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "apikey \(NewsService.API_KEY)"
        ]
    }
    
    var baseURL: URL {
        return URL(string: NewsService.BASE_URL)!
    }
}
