//
//  FavoritesVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 7.10.2024.
//

import UIKit
import FirebaseAuth

class FavoritesVC: UIViewController {
    @IBOutlet weak var favTitleLbl: UILabel!
    @IBOutlet weak var favTableView: UITableView!
    
    private let viewModel = FavoritesViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
        updateFavorites()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites), name: NSNotification.Name("FavoriteNewsUpdated"), object: nil)
    }
    
    private func bindViewModel() {
        viewModel.onFavoritesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.favTableView.reloadData()
            }
        }
        
        viewModel.onError = { error in
            print("Error loading favorites: \(error)")
        }
    }
    
    @objc private func updateFavorites() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        viewModel.loadFavorites(for: userId)
    }
    
    private func configureTableView() {
        favTableView.dataSource = self
        favTableView.delegate = self
        favTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FavoriteNewsUpdated"), object: nil)
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let newsItem = viewModel.favoriteNews[indexPath.row]
        cell.tagTitleLbl.text = newsItem.source
        cell.newsTitleLbl.text = newsItem.name
        cell.newsDescLbl.text = newsItem.description
        cell.newsDescLbl.numberOfLines = 3
        if let imageUrl = URL(string: newsItem.image) {
            cell.newsImageView.af.setImage(withURL: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        } else {
            cell.newsImageView.image = UIImage(named: "placeholder")
        }
        
//        if newsItem.isFavorite {
//            cell.favImageView.image = UIImage(named: "SelectedFavorite")
//        } else {
//            cell.favImageView.image = UIImage(named: "NonselectedFavorite") 
//        }

        return cell
    }
    
    
}
