//
//  Color+Ext.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 10.10.2024.
//

import UIKit

extension UIColor {
    convenience init(_ hex: String) {
        var hexFormatted: String = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static let newsLabelColor = UIColor("#090816")
    static let categoryCellViewColor = UIColor("#ECECEC")
    static let categoryCellLabelColor = UIColor("#9C9C9C")
}
