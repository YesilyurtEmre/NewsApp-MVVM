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
            if let error = error {
                let errorMessage = self.getErrorMessage(for: error)
                completion(false, errorMessage)
                return
            }
            completion(true, nil)
        }
    }
    
    private func getErrorMessage(for error: Error) -> String {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return "Geçersiz e-posta adresi."
        case AuthErrorCode.userNotFound.rawValue:
            return "Bu e-posta adresi ile kayıtlı bir kullanıcı bulunamadı."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Şifre yanlış. Lütfen tekrar deneyin."
        case AuthErrorCode.userDisabled.rawValue:
            return "Bu kullanıcı hesabı devre dışı bırakılmış."
        case AuthErrorCode.operationNotAllowed.rawValue:
            return "Bu işlem için hesap doğrulanmamış veya izin verilmemiş."
        default:
            return "Bilinmeyen bir hata oluştu: \(error.localizedDescription)"
        }
    }
}
