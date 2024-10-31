//
//  LoginViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        AuthManager.shared.loginUser(email: email, password: password) { isSuccess, error in
            if isSuccess {
                completion(isSuccess, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
