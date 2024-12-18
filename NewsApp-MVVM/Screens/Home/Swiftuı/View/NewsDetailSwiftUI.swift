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
            if let imageUrl = viewModel.newsImageUrl {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .cornerRadius(8)
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .padding()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Text(viewModel.newsSource)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.horizontal, 10)
            
            Text(viewModel.newsTitle)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal, 10)
            
            Text(viewModel.newsDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal, 10)
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
