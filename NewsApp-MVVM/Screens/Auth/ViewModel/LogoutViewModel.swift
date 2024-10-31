//
//  LogoutViewModel.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 31.10.2024.
//

import Foundation

class LogoutViewModel {
    let logoutTitle = "Çıkış Yap"
    let logoutMessage = "Çıkış yapmak istediğinize emin misiniz?"
    let confirmButtonTitle = "Evet"
    let cancelButtonTitle = "İptal"
    
    func getProfileSettingsCount() -> Int {
        ProfileSettings.allCases.count
    }
}
