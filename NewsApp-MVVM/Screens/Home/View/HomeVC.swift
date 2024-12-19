//
//  HomeVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 7.10.2024.
//

import UIKit
import SwiftUI

final class HomeVC: BaseVC {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var newsTableView: UITableView!
    
    private lazy var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureCollectionView()
        configureTableView()
        viewModel.registerCells(for: categoryCollectionView, and: newsTableView)
        fetchNewsData()
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChanged(_:)), name: .favoriteStatusChanged, object: nil)
        hostingControllerSetup()
    }
    
    private func hostingControllerSetup() {
//        let viewModel = SwiftUIViewModel()
        let swiftUIView = HomeView(viewModel: SwiftUIViewModel())
        
        // HostingController ile SwiftUI görünümünü UIKit'e ekle
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // SwiftUI görünümünü mevcut UIView'a ekle
        view.addSubview(hostingController.view)
        
        // Auto Layout ayarları
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    @objc func handleFavoriteStatusChanged(_ notification: Notification) {
        if let newsItem = notification.userInfo?["newsItem"] as? NewsItem {
            if let index = viewModel.newsItems.firstIndex(where: { $0.key == newsItem.key }) {
                viewModel.newsItems[index].isFavorite = newsItem.isFavorite
            }
            newsTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func fetchNewsData() {
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }
            viewModel.fetchNews()
        }
    }
    
    private func configureCollectionView() {
        
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
        let cell = newsTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.newsCell, for: indexPath) as! NewsCell
        let newsItem = viewModel.newsItems[indexPath.row]
        cell.configureCell(newsItem: newsItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toNewsDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewsDetail" {
            if let indexPath = sender as? IndexPath,
               let detailVC = segue.destination as? NewsDetailVC {
                let selectedNews = viewModel.getNewsItem(at: indexPath)
                let detailViewModel = NewsDetailViewModel(news: selectedNews, isFavorite: true)
                detailVC.viewModel = detailViewModel
            }
        }
    }
}

// MARK: - CollectionView
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCategoriesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.categoryCell, for: indexPath) as! CategoryCell
        let category = Categories(rawValue: indexPath.item)
        let isSelected = category == viewModel.selectedCategory
        cell.configureCell(with: category!, isSelected: isSelected)
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

extension HomeVC: HomeViewModelProtocol {
    func reloadData() {
        self.indicator.stopAnimating()
        newsTableView.reloadData()
    }
}
