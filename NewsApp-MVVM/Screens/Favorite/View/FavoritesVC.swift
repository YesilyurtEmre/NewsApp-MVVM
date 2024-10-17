//
//  FavoritesVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 7.10.2024.
//

import UIKit

class FavoritesVC: UIViewController {
    @IBOutlet weak var favTitleLbl: UILabel!
    @IBOutlet weak var favTableView: UITableView!
    
    var favoriteNews: [NewsItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let newsItem = favoriteNews[indexPath.row]
        cell.newsItem = newsItem
        cell.isFavorite = true
        return cell
    }
    
    
}
