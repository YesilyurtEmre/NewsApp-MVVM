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
            return Constants.loginError
        }
        switch errorCode {
        case .invalidEmail:
            return Constants.invalidEmail
        case .userNotFound:
            return Constants.userNotFound
        case .wrongPassword:
            return Constants.wrongPassword
        default:
            return Constants.defaultError
        }
    }
}
