//
//  HomeView.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.12.2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: SwiftUIViewModel
    
    var body: some View {
        VStack() {
            Text("Google News")
                .font(.title2)
                .fontWeight(.heavy)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .top)
            
            ScrollView(.horizontal) {
                HStack {
                    Spacer(minLength: 20)
                    ForEach(0..<viewModel.getCategoriesCount(), id: \.self) { index in
                        let category = Categories(rawValue: index)
                        let isSelected = category == viewModel.selectedCategory
                        CategoryButton(category: category, isSelected: isSelected) {
                            selectCategory(index: index)
                        }
                    }
                }
            }
            List(viewModel.newsItems) { newsItem in
                NavigationLink(destination: NewsDetailSwiftUI(viewModel: NewsDetailViewModel( news: newsItem))) {
                    NewsRow(newsItem: newsItem)
                }
            }
            .listStyle(.plain)
            .padding(.horizontal)
            Spacer()
        }
    }
    
    
    func selectCategory(index: Int) {
        viewModel.selectedCategoryIndex = index
        viewModel.selectedCategory = Categories(rawValue: index)!
        viewModel.fetchNews()
    }
    
    struct CategoryButton: View {
        var category: Categories?
        var isSelected: Bool
        var action: () -> Void
        
        var body: some View {
            Text(category?.title ?? "")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background(isSelected ? .white : .black)
                .foregroundColor(isSelected ? .black : .white)
                .cornerRadius(8)
                .onTapGesture {
                    action()
                }
        }
    }
    
    struct NewsRow: View {
        @State var newsItem: NewsItem
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                if let imageUrl = URL(string: newsItem.image) {
                    AsyncImage(url: imageUrl) { image in
                        image.resizable()
                            .cornerRadius(8)
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                Text(newsItem.source)
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(newsItem.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(newsItem.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
    }
}

#Preview {
    HomeView(viewModel: SwiftUIViewModel())
}
