//
//  LoginViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                let errorMessage = self.handleErrorMessage(error)
                completion(false, errorMessage)
                return
            }
            completion(true, nil)
        }
    }
    
    func handleErrorMessage(_ error: NSError) -> String {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return String.loginError
        }
        switch errorCode {
        case .invalidEmail:
            return "Lütfen geçerli bir e-posta adresi girin."
        case .userNotFound:
            return "Bu e-posta adresi ile kayıtlı bir kullanıcı bulunamadı." // bu hata gelmiyor
        case .wrongPassword:
            return "Şifre yanlış. Lütfen tekrar deneyin." // bu hata gelmiyor
        default:
            return "Bilinmeyen bir hata oluştu lütfen tekrar deneyin"
        }
    }
}
