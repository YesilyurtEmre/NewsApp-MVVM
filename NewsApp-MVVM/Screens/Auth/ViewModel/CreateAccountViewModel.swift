//
//  CreateAccountViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import Foundation
import FirebaseAuth
import UIKit

protocol CreateAccountViewModelDelegate: AnyObject {
    func didValidateFields(success: Bool, errorMessage: String?)
    func didCreateAccount(success: Bool, message: String?)
}

class CreateAccountViewModel {
    
    weak var delegate: CreateAccountViewModelDelegate?
    
    func nextResponder(for textField: UITextField, in textFields: [UITextField]) -> UITextField? {
        guard let index = textFields.firstIndex(of: textField), index < textFields.count - 1 else {
            return nil
        }
        return textFields[index + 1]
    }
    
    func placeholders() -> [String] {
        return [
            "Adınızı girin",
            "E-posta adresinizi girin",
            "Şifrenizi girin",
            "Şifrenizi tekrar girin"
        ]
    }
    
    func validateFields(email: String?, password: String?, confirmPassword: String?) {
        
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty,
              let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            delegate?.didValidateFields(success: false, errorMessage: Constants.AuthMessages.requiredFields)
            
            return
        }
        
        guard password == confirmPassword else {
            delegate?.didValidateFields(success: false, errorMessage: Constants.AuthMessages.passwordMismatch)
            
            return
        }
        delegate?.didValidateFields(success: true, errorMessage: nil)
    }
    
    func createAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error as NSError? {
                let customMessage = self?.handleFirebaseError(error)
                self?.delegate?.didCreateAccount(success: false, message: customMessage)
                return
            }
            self?.delegate?.didCreateAccount(success: true, message: nil)
        }
    }
    
    private func handleFirebaseError(_ error: NSError) -> String {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return Constants.AuthMessages.loginError
        }
        switch errorCode {
        case .invalidEmail:
            return Constants.AuthMessages.invalidEmail
        case .emailAlreadyInUse:
            return Constants.AuthMessages.alreadyInUse
        default:
            return Constants.AuthMessages.defaultError
        }
    }
}


