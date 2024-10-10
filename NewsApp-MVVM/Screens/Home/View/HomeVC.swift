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
    var tag: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNewsData()
        configureCollectionView()
        configureTableView()
    }
    
    func fetchNewsData() {
        viewModel.fetchNews { [weak self] in
            DispatchQueue.main.async {
                self?.newsTableView.reloadData()
            }
            
        }
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
        
        viewModel.selectedCategoryIndex = IndexPath(item: 0, section: 0)
        categoryCollectionView.selectItem(at: viewModel.selectedCategoryIndex, animated: false, scrollPosition: [])
    }
}

// MARK: - TableView
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNewsItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let newsItem = viewModel.newsItems[indexPath.row]
        cell.configureCell(newsItem: newsItem)
        cell.indexPath = indexPath
        return cell
    }
    
    
}

// MARK: - CollectionView
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCategoriesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = Categories(rawValue: indexPath.item)
        
        if category == viewModel.selectedCategory {
            cell.categoryCellView.backgroundColor = .white
            cell.categoryCellLbl.text = category?.title
            cell.categoryCellLbl.textColor = .black
        } else {
            cell.categoryCellView.backgroundColor = UIColor("#ECECEC")
            cell.categoryCellLbl.text = category?.title
            cell.categoryCellLbl.textColor = UIColor("#9C9C9C")
        }
        
        cell.categoryCellLbl.lineBreakMode = .byWordWrapping
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndexPath = viewModel.selectedCategoryIndex
        viewModel.selectedCategoryIndex = indexPath
        viewModel.selectedCategory = Categories(rawValue: indexPath.item)!
        
        fetchNewsData()
        
        UIView.performWithoutAnimation {
            var indexPathsToReload: [IndexPath] = []
            if let previous = previousIndexPath {
                indexPathsToReload.append(previous)
            }
            indexPathsToReload.append(indexPath)
            
            collectionView.reloadItems(at: indexPathsToReload)
        }
    }
}
