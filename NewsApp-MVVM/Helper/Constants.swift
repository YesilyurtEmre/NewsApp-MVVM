//
//  Constants.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 25.10.2024.
//

import Foundation

struct Constants {
    
    struct AuthMessages {
        static let registrationSuccess = "Kayıt başarılı! Giriş yapabilirsiniz."
        static let emptyEmail = "Email boş bırakılamaz."
        static let emptyPassword = "Şifre boş bırakılamaz"
        static let loginError = "Bir hata oluştu."
        static let passwordMismatch = "Şifreler eşleşmiyor."
        static let requiredFields = "Tüm alanlar doldurulmalıdır."
        
        static let invalidEmail = "Lütfen geçerli bir e-posta adresi girin."
        static let userNotFound = "Bu e-posta adresi ile kayıtlı bir kullanıcı bulunamadı."
        static let wrongPassword = "Şifre yanlış. Lütfen tekrar deneyin."
        static let defaultError = "Bilinmeyen bir hata oluştu lütfen tekrar deneyin"
        static let alreadyInUse = "Bu e-posta adresi zaten kullanılıyor."
    }
    
    struct Errors {
        static let invalidUUID = "Geçersiz UUID formatı:"
        static let decodingError = "Error decoding document:"
        static let firestoreError = "Firestore error:"
    }
    
    struct FirestoreKeys {
        static let collectionName = "FavoriteNews"
        static let id = "id"
        static let key = "key"
        static let url = "url"
        static let description = "description"
        static let image = "image"
        static let name = "name"
        static let source = "source"
        static let email = "email"
    }
    
    struct StoryboardIdentifiers {
        static let createAccountStoryboard = "CreateAccount"
        static let createAccountVC = "CreateAccountVC"
        static let mainStoryboard = "Main"
        static let tabBarController = "TabBarController"
        static let HomeStoryboard = "Home"
        static let HomeVC = "HomeVC"
        static let LoginStoryboard = "Login"
        static let LoginVC = "LoginVC"
    }
    
    struct SFSymbols {
        static let magnifyingGlass = "magnifyingglass"
        static let closeCircle = "xmark.circle"
    }
    
    struct CellIdentifiers {
        static let newsCell = "NewsCell"
        static let categoryCell = "CategoryCell"
    }
    
}


