//
//  CategoryButton.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 23.12.2024.
//

import SwiftUI

struct CategoryButton: View {
    var category: Categories?
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Text(category?.title ?? "")
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .background(isSelected ? .white : .gray)
            .foregroundColor(isSelected ? .black : .white)
            .cornerRadius(8)
            .onTapGesture {
                action()
            }
    }
}

