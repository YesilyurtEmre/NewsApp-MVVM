//
//  LoginVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var LoginTitleLbl: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextfield.text, !email.isEmpty else {
            showMessage(String.emptyEmail)
            return
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            showMessage(String.emptyPassword)
            return
        }
        
        loginViewModel.login(email: email, password: password) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
                        tabBarController.modalPresentationStyle = .fullScreen
                        self?.present(tabBarController, animated: true, completion: nil)
                    }
                } else {
                    self?.showMessage(message ?? String.loginError)
                }
            }
        }
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreateAccount", bundle: nil)
        if let createAccountVC = storyboard.instantiateViewController(withIdentifier: "CreateAccountVC") as? CreateAccountVC {
            createAccountVC.modalPresentationStyle = .fullScreen
            present(createAccountVC, animated: true, completion: nil)
        }
    }
    
    private func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
