//
//  CreateAccountViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import Foundation
import FirebaseAuth

class CreateAccountViewModel {
    
    func createAccount(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
}


