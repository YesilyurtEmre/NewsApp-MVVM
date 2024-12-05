//
//  APIServices.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//



import Foundation
import Alamofire
import Moya

final class APIServices {
    
    static let shared = APIServices()
    private let provider = MoyaProvider<NewsService>()
    private init() {}
    
    func fetchNews(category: Categories, completion: @escaping (Result<[NewsItem], Error>) -> Void) {
        provider.request(.fetchNews(category: category)) { result in
            switch result {
            case .success(let response):
                do {
                    let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: response.data)
                    if newsResponse.success {
                        completion(.success(newsResponse.result))
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "API hatası: Başarı durumu false."])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}




