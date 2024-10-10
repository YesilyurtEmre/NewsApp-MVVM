//
//  Categories.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import Foundation

enum Categories: Int, CaseIterable {
    case general
    case sport
    case economy
    case technology
    
    var title: String {
        switch self {
        case .general:
            return "Genel"
        case .sport:
            return "Spor"
        case .economy:
            return "Ekonomi"
        case .technology:
            return "Teknoloji"
        }
    }
    
    var tag: String {
        switch self {
        case .general:
            return "general"
        case .sport:
            return "sport"
        case .economy:
            return "economy"
        case .technology:
            return "technology"
        }
    }
}

