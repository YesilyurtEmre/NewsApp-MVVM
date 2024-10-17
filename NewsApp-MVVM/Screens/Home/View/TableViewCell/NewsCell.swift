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
    
    var newsItem: NewsItem?
    var indexPath: IndexPath?
    var news: [NewsItem] = []
    var isFavorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(newsItem: NewsItem) {
        tagTitleLbl.text = newsItem.source
        newsTitleLbl.text = newsItem.name
        newsTitleLbl.textColor = .black
        newsTitleLbl.font = UIFont(name: "Montserrat-Light", size: 12)
        newsTitleLbl.numberOfLines = 2
        newsTitleLbl.lineBreakMode = .byTruncatingTail
        newsTitleLbl.textColor = UIColor("#090816")
        newsTitleLbl.font = UIFont(name: "Montserrat-Medium", size: 16)
        newsDescLbl.numberOfLines = 3
        newsDescLbl.lineBreakMode = .byTruncatingTail
        newsDescLbl.text = newsItem.description
        newsDescLbl.textColor = UIColor("#090816")
        newsDescLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
        
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
