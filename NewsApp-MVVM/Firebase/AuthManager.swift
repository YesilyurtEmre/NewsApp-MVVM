//
//  AuthManager.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 25.10.2024.
//

import Foundation
import FirebaseAuth


class AuthManager {
    static let shared = AuthManager()
    
    private(set) var currentUser: User?
    
    private init() {}
    
    func loginUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                completion(false, error)
            } else if let authResult = authResult {
                let uid = authResult.user.uid
                self.currentUser = User(email: email, password: password, userID: uid)
                completion(true, nil)
            }
        }
    }
    
    func logoutUser() {
        try? Auth.auth().signOut()
        self.currentUser = nil
    }
    
    func handleErrorMessage(_ error: NSError) -> String {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return Constants.AuthMessages.loginError
        }
        switch errorCode {
        case .invalidEmail:
            return Constants.AuthMessages.invalidEmail
        case .userNotFound:
            return Constants.AuthMessages.userNotFound
        case .wrongPassword:
            return Constants.AuthMessages.wrongPassword
        default:
            return Constants.AuthMessages.defaultError
        }
    }
}
