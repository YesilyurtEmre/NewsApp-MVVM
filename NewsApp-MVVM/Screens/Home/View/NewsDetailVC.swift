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
    
    var viewModel: NewsDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        self.navigationItem.hidesBackButton = false
        self.navigationItem.title = "Google News"
        let backButtonTapped = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButtonTapped
        backButtonTapped.tintColor = .black
    }
    
    func configureUI() {
        if let imageUrl = viewModel.newsImageUrl {
            detailImageView.af.setImage(withURL: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        } else {
            detailImageView.image = UIImage(named: "placeholder")
        }
        
        detailTagLbl.text = viewModel.newsSource
        detailTitleLbl.text = viewModel.newsTitle
        detailDescLbl.text = viewModel.newsDescription
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
