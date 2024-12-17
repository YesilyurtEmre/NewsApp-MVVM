//
//  NewsDetailSwiftUI.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.12.2024.
//

import SwiftUI

struct NewsDetailSwiftUI: View {
    @ObservedObject var viewModel: NewsDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
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
                .padding()
            Text(viewModel.newsTitle)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
            
            Text(viewModel.newsDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .navigationTitle("News Detail")
        .font(.title2)
        .fontWeight(.heavy)
        .padding(.top, 10)
        .frame(maxWidth: .infinity, alignment: .top)
        
    }
}

//struct NewsDetailSwiftUI_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsDetailSwiftUI(viewModel: NewsDetailViewModel(news: NewsItem))
//    }
//}
