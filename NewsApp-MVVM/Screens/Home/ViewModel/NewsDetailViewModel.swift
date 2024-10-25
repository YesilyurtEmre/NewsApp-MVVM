//
//  NewsDetailViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 23.10.2024.
//
import Foundation

class NewsDetailViewModel {
    var news: NewsItem?
    
    init(news: NewsItem) {
        self.news = news
    }
    
    var newsTitle: String {
        return news?.name ?? ""
    }
    
    var newsDescription: String {
        return news?.description ?? ""
    }
    
    var newsSource: String {
        return news?.source ?? ""
    }
    
    var newsImageUrl: URL? {
        guard let imageUrl = news?.image else { return nil }
        return URL(string: imageUrl)
    }
}
