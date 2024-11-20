//
//  LoginViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import Foundation
import FirebaseAuth
import UIKit

class LoginViewModel {
    
    func nextResponder(for textField: UITextField, textFieldOrder: [UITextField]) -> UITextField? {
        guard let index = textFieldOrder.firstIndex(of: textField), index < textFieldOrder.count - 1 else {
            return nil
        }
        return textFieldOrder[index + 1]
    }
    
    func placeholders() -> [String] {
        return [
            "E-posta adresinizi girin",
            "Şifrenizi girin"
        ]
    }
    
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
