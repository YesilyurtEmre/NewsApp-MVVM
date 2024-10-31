//
//  LogoutVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 31.10.2024.
//

import UIKit

class LogoutVC: UIViewController {
    @IBOutlet weak var profileTitleLbl: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    var viewModel = LogoutViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.register(UINib(nibName: "ProfileSettingsCell", bundle: nil), forCellReuseIdentifier: "ProfileSettingsCell")
    }
}

extension LogoutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getProfileSettingsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSettingsCell", for: indexPath) as! ProfileSettingsCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: viewModel.logoutTitle,
                                      message: viewModel.logoutMessage,
                                      preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: viewModel.confirmButtonTitle, style: .default) { _ in
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: viewModel.cancelButtonTitle, style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
