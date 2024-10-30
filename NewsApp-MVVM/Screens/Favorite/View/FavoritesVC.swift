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
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChanged(_:)), name: .favoriteStatusChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
    
    @objc func handleFavoriteStatusChanged(_ notification: Notification) {
        if let newsItem = notification.userInfo?["newsItem"] as? NewsItem {
            viewModel.updateFavoriteStatus(for: newsItem)
            viewModel.loadFavorites()
            favTableView.reloadData()
        }
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
    
    private func configureTableView() {
        favTableView.dataSource = self
        favTableView.delegate = self
        favTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let newsItem = viewModel.favoriteNews[indexPath.row]
        cell.configureCell(newsItem: newsItem)
        return cell
    }
}
