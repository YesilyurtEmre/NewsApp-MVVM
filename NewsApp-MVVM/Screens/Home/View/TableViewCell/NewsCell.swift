//
//  NewsCell.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import UIKit
import AlamofireImage

class NewsCell: UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var tagTitleLbl: UILabel!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsDescLbl: UILabel!
    
    var newsItem: NewsItem? {
        didSet {
            updateFavImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFavImageTapGesture()
    }
    
    private func setupFavImageTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favImageTapped))
        favImageView.isUserInteractionEnabled = true
        favImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func favImageTapped() {
        guard var item = newsItem else { return }
        if item.isFavorite {
            item.isFavorite = false
            FavoriteNewsManager.shared.removeFavorite(newsID: item.id.uuidString) { error in
                if let error = error {
                    print("Error removing favorite: \(error)")
                } else {
                    print("Favori olarak kaldırıldı: \(item.name)")
                }
            }
        } else {
            item.isFavorite = true
            item.userId = AuthManager.shared.currentUser?.userID
            FavoriteNewsManager.shared.addFavorite(news: item) { error in
                if let error = error {
                    print("Error adding favorite: \(error)")
                } else {
                    print("Favori olarak eklendi: \(item.name)")
                }
            }
        }
        newsItem = item
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: nil, userInfo: ["newsItem": item])
    }
    
    private func updateFavImage() {
        guard let newsItem = newsItem else { return }
        let imageName = newsItem.isFavorite ? "SelectedFavorite" : "NonselectedFavorite"
        favImageView.image = UIImage(named: imageName)
    }
    
    func configureCell(newsItem: NewsItem) {
        self.newsItem = newsItem
        tagTitleLbl.text = newsItem.source
        tagTitleLbl.font = UIFont.montserrat(.light, size: 14)
        newsTitleLbl.text = newsItem.name
        newsTitleLbl.font = UIFont.montserrat(.medium, size: 18)
        newsTitleLbl.textColor = .black
        newsTitleLbl.numberOfLines = 2
        newsTitleLbl.lineBreakMode = .byTruncatingTail
        newsTitleLbl.textColor = UIColor.newsLabelColor
        newsDescLbl.numberOfLines = 3
        newsDescLbl.font = UIFont.montserrat(.regular, size: 16)
        newsDescLbl.lineBreakMode = .byTruncatingTail
        newsDescLbl.text = newsItem.description
        newsDescLbl.textColor = UIColor.newsLabelColor
        
        if let imageUrl = URL(string: newsItem.image) {
            newsImageView.af.setImage(withURL: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        } else {
            newsImageView.image = UIImage(named: "placeholder")
        }
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
