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

protocol LoginViewModelInterface {
    
    func textFieldShouldReturn(_ textField: UITextField, textFieldOrder: [UITextField]) -> Bool
    func handleLogin(email: String?, password: String?)
}

final class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    func nextResponder(for textField: UITextField, textFieldOrder: [UITextField]) -> UITextField? {
        guard let index = textFieldOrder.firstIndex(of: textField), index < textFieldOrder.count - 1 else {
            return nil
        }
        return textFieldOrder[index + 1]
    }
    
    
    func validateFields(email: String?, password: String?) -> String? {
        if email == nil || email!.isEmpty {
            return Constants.AuthMessages.emptyEmail
        }
        
        if password == nil || password!.isEmpty {
            return Constants.AuthMessages.emptyPassword
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


extension LoginViewModel: LoginViewModelInterface {
    
    func handleLogin(email: String?, password: String?) {
        if let validationError = validateFields(email: email, password: password) {
            delegate?.didFailToLogin(error: validationError)
            return
        }
        login(email: email ?? "", password: password ?? "")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField, textFieldOrder: [UITextField]) -> Bool {
        if let nextField = nextResponder(for: textField, textFieldOrder: textFieldOrder) {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
