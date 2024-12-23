//
//  NewsDetailSwiftUI.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.12.2024.
//

import SwiftUI

struct NewsDetailSwiftUI: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: NewsDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            if let news = viewModel.news {
                NewsRow(newsItem: news, toggleFavorite: nil, showFavoriteButton: false)
                    .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                }
            }
        }
        .navigationTitle("News Detail")
        .font(.title2)
        .fontWeight(.heavy)
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: .top)
        Spacer()
        
    }
}

//#Preview {
//    let news = NewsItem
//    NewsDetailSwiftUI(viewModel: NewsDetailViewModel(news: NewsItem, isFavorite: false))
//}
//
