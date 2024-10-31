//
//  TabBarController.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        
    }
   
    func setupTabBarItems() {
        guard let items = tabBar.items else {
            print("Tab bar items are nil.")
            return
        }
        
        let nonSelectedHomeImg = UIImage(named: "NonselectedHome")?.withRenderingMode(.alwaysOriginal)
        let selectedHomeImg = UIImage(named: "SelectedHome")?.withRenderingMode(.alwaysOriginal)
        items[0].image = nonSelectedHomeImg
        items[0].selectedImage = selectedHomeImg
        
        
        let nonSelectedSearchImg = UIImage(named: "NonselectedSearch")?.withRenderingMode(.alwaysOriginal)
        let selectedSearchImg = UIImage(named: "SelectedSearch")?.withRenderingMode(.alwaysOriginal)
        items[1].image = nonSelectedSearchImg
        items[1].selectedImage = selectedSearchImg
        
        
        
        let nonSelectedFavImg = UIImage(named: "NonselectedFavorite")?.withRenderingMode(.alwaysOriginal)
        let selectedFavImg = UIImage(named: "SelectedFavorite")?.withRenderingMode(.alwaysOriginal)
        items[2].image = nonSelectedFavImg
        items[2].selectedImage = selectedFavImg
        
        let nonSelectedProfileImg = UIImage(named: "NonselectedFavorite")?.withRenderingMode(.alwaysOriginal)
        let selectedProfileImg = UIImage(named: "SelectedFavorite")?.withRenderingMode(.alwaysTemplate)
        items[3].image = nonSelectedFavImg
        items[3].selectedImage = selectedFavImg
    }
}
