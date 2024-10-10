//
//  HomeVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 7.10.2024.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var newsTableView: UITableView!
    
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNewsData()
        configureCollectionView()
        configureTableView()
    }
    
    func fetchNewsData() {
        viewModel.fetchNews()
    }
    
    private func configureCollectionView() {
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        categoryCollectionView.register(nib, forCellWithReuseIdentifier: "CategoryCell")
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.allowsSelection = true
        
        let design = UICollectionViewFlowLayout()
        design.scrollDirection = .horizontal
        design.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        design.minimumInteritemSpacing = 10
        design.minimumLineSpacing = 10
    }
    
    private func configureTableView() {
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        return cell
    }
    
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        return cell
    }
    
    
}


