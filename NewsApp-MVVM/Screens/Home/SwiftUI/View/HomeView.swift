//
//  HomeView.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.12.2024.
//

import SwiftUI
import AlamofireImage


struct HomeView: View {
    @ObservedObject var viewModel: SwiftUIViewModel
    
    var body: some View {
        VStack {
            navigationTitle()
            categoryList()
            newsList()
        }
    }
    
    @ViewBuilder
    private func navigationTitle() -> some View {
        Text("Google News")
            .font(.title2)
            .font(.system(size: 17, weight: .medium))
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    private func categoryList() -> some View {
        ScrollView(.horizontal) {
            HStack() {
                Spacer(minLength: 20)
                ForEach(0..<viewModel.getCategoriesCount(), id: \.self) { index in
                    let category = Categories(rawValue: index)
                    let isSelected = category == viewModel.selectedCategory
                    CategoryButton(category: category, isSelected: isSelected) {
                        selectCategory(index: index)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func newsList() -> some View {
        List(viewModel.newsItems) { newsItem in
            ZStack {
                NewsRow(newsItem: newsItem) {
                    viewModel.toggleFavorite(for: newsItem)
                }
                NavigationLink(destination: NewsDetailSwiftUI(viewModel: NewsDetailViewModel(news: newsItem))) {
                    EmptyView()
                }
                .opacity(0.0)
            }
        }
        .id(UUID())
        .listStyle(.plain)
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
    
    
    func selectCategory(index: Int) {
        viewModel.selectedCategoryIndex = index
        viewModel.selectedCategory = Categories(rawValue: index)!
        viewModel.fetchNews()
    }
}

#Preview {
    HomeView(viewModel: SwiftUIViewModel())
}
