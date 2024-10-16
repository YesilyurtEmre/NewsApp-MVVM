//
//  NewsDetailVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 14.10.2024.
//

import UIKit

class NewsDetailVC: BaseVC {
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTagLbl: UILabel!
    @IBOutlet weak var detailTitleLbl: UILabel!
    @IBOutlet weak var detailDescLbl: UILabel!
    
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let newsItem = viewModel.news {
            if let imageUrl = URL(string: newsItem.image) {
                detailImageView.af.setImage(withURL: imageUrl, placeholderImage: UIImage(named: "placeholder"))
            } else {
                detailImageView.image = UIImage(named: "placeholder")
            }
            detailTagLbl.text = newsItem.source
            detailTitleLbl.text = newsItem.name
            detailDescLbl.text = newsItem.description
        }
        
        self.navigationItem.hidesBackButton = false
        self.navigationItem.title = "Google News"
        let backButtonTapped = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButtonTapped
        backButtonTapped.tintColor = .black
        
        
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
