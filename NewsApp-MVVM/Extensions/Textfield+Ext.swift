//
//  Textfield+Ext.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 19.11.2024.
//

import Foundation
import UIKit

extension UITextField {
    func setDynamicPlaceholder(_ placeholder: String) {
        let dynamicColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray
        }
        
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: dynamicColor]
        )
    }
}

