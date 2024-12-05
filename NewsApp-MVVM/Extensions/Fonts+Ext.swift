//
//  Fonts+Ext.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 5.12.2024.
//

import Foundation
import UIKit

extension UIFont {
    
    static func montserrat(_ font: MontserratFonts, size: CGFloat) -> UIFont {
        if let montserrat = UIFont(name: font.name, size: size) {
            return montserrat
        } else {
            debugPrint("montserrat font fail")
            return UIFont(name: "Montserrat-Regular", size: size)!
        }
    }
}

enum MontserratFonts {
    case light, medium, regular
    
    var name: String {
        switch self {
        case .light: return "Montserrat-Light"
        case .medium: return "Montserrat-Medium"
        case .regular: return "Montserrat-Regular"
        }
    }
}
