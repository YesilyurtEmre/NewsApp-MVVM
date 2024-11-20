//
//  LoginViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import Foundation
import FirebaseAuth
import UIKit

protocol LoginViewModelDelegate: AnyObject {
    func didLoginSuccessfully()
    func didFailToLogin(error: String)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
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
    
    func validateFields(email: String?, password: String?) -> String? {
        if email == nil || email!.isEmpty {
            return Constants.emptyEmail
        }
        
        if password == nil || password!.isEmpty {
            return Constants.emptyPassword
        }
        
        return nil
    }
    
    func login(email: String, password: String) {
        AuthManager.shared.loginUser(email: email, password: password) { [weak self] isSuccess, error in
            if isSuccess {
                self?.delegate?.didLoginSuccessfully()
            } else {
                let errorMessage = error?.localizedDescription ?? "Giriş başarısız!"
                self?.delegate?.didFailToLogin(error: errorMessage)
            }
        }
    }
}
