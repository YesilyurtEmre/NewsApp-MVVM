//
//  APIServices.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//



import Foundation
import Alamofire

final class APIServices {

    static let shared = APIServices()
    private init() {}

    private let headers: HTTPHeaders = [
        "content-type": "application/json",
        "authorization": "apikey \(EndPoints.API_KEY)"
    ]

    func fetchNews(category: Categories, completion: @escaping (Result<[NewsItem], Error>) -> Void) {
        let url = EndPoints.getNews(category.tag).url

        AF.request(url, method: .get, headers: headers).responseDecodable(of: NewsResponse.self) { response in
            switch response.result {
            case .success(let newsResponse):
                if newsResponse.success {
                    completion(.success(newsResponse.result))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "API hatası: Başarı durumu false."])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}




