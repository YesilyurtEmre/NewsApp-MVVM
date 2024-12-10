//
//  SearchVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 7.10.2024.
//

import UIKit

class SearchVC: UIViewController {
    @IBOutlet weak var searchLbl: UILabel!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    
    var viewModel = SearchViewModel()
    
    let textField = UITextField()
    let searchIcon = UIImageView(image: UIImage(systemName: Constants.SFSymbols.magnifyingGlass))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureTableView()
        setupSearchBarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.text = ""
        viewModel.searchNews(searchText: "")
        searchIcon.image = UIImage(systemName: Constants.SFSymbols.magnifyingGlass)
    }
    
    private func setupSearchBarView() {
        textField.placeholder = "Ara"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 17.5
        textField.isUserInteractionEnabled = true
        textField.keyboardType = .default
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 35))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        searchBarView.addSubview(textField)
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -15),
            textField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        searchIcon.tintColor = .lightGray
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.contentMode = .scaleAspectFit
        searchBarView.addSubview(searchIcon)
        
        NSLayoutConstraint.activate([
            searchIcon.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchIcon.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -25),
            searchIcon.widthAnchor.constraint(equalToConstant: 25),
            searchIcon.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchIconTapped))
        searchIcon.isUserInteractionEnabled = true
        searchIcon.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func searchIconTapped() {
        textField.text = ""
        viewModel.searchNews(searchText: "")
        searchIcon.image = UIImage(systemName: Constants.SFSymbols.magnifyingGlass)
        viewModel.isSearching = false
    }
    
    private func updateTableView() {
        searchTableView.reloadData()
    }
    
    private func configureTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: Constants.CellIdentifiers.newsCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.newsCell)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let searchText = textField.text {
            viewModel.searchNews(searchText: searchText)
            searchIcon.image = searchText.isEmpty ?
            UIImage(systemName: Constants.SFSymbols.magnifyingGlass) :
            UIImage(systemName: Constants.SFSymbols.closeCircle)
        }
    }
}


extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredNewsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.newsCell, for: indexPath) as! NewsCell
        let searchNews = viewModel.filteredNews[indexPath.row]
        cell.configureCell(newsItem: searchNews)
        return cell
    }
}

extension SearchVC: SearchViewModelProtocol {
    func loadNews() {
        updateTableView()
    }
}
