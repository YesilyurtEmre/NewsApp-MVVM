//
//  ProfileSettings.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 31.10.2024.
//

import Foundation

enum ProfileSettings: Int, CaseIterable {
    case logout
    
    var title : String {
        switch self {
        case .logout:
            return "Logout"
        }
    }
    
}

