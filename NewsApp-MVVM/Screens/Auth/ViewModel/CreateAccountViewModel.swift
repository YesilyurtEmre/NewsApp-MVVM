//
//  CreateAccountViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import Foundation
import FirebaseAuth

class CreateAccountViewModel {
    
    func validateFields(email: String?, password: String?, confirmPassword: String?) -> (isValid: Bool, errorMessage: String?) {
        
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty,
              let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            return (false, Constants.requiredFields)
        }
        
        guard password == confirmPassword else {
            return (false, Constants.passwordMismatch)
        }
        
        return (true, nil)
    }
    
    func createAccount(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                let customMessage = self.handleFirebaseError(error)
                completion(false, customMessage)
                return
            }
            completion(true, nil)
        }
    }
    
    private func handleFirebaseError(_ error: NSError) -> String {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return Constants.loginError
        }
        switch errorCode {
        case .invalidEmail:
            return "Lütfen geçerli bir e-posta adresi girin."
        case .emailAlreadyInUse:
            return "Bu e-posta adresi zaten kullanılıyor."
        default:
            return "Bir hata oluştu. Lütfen tekrar deneyin."
        }
    }
}


