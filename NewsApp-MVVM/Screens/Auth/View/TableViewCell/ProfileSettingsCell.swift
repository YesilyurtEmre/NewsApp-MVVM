//
//  ProfileSettingsCell.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 31.10.2024.
//

import UIKit

class ProfileSettingsCell: UITableViewCell {
    @IBOutlet weak var logoutLbl: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureLogoutButton()
    }
    
    private func configureLogoutButton() {
        let chevronImage = UIImage(systemName: "chevron.right")
        logoutButton.setImage(chevronImage, for: .normal)
        logoutButton.tintColor = .gray
        logoutButton.isUserInteractionEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
