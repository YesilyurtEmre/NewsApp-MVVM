//
//  LoginVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var LoginTitleLbl: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            passwordTextfield.becomeFirstResponder()
        } else if textField == passwordTextfield {
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func configureTextFields() {
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        
        emailTextfield.setDynamicPlaceholder("E-posta adresinizi girin")
        passwordTextfield.setDynamicPlaceholder("Şifrenizi girin")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextfield.text, !email.isEmpty else {
            showMessage(Constants.emptyEmail)
            return
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            showMessage(Constants.emptyPassword)
            return
        }
        
        loginViewModel.login(email: email, password: password) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
                        tabBarController.modalPresentationStyle = .fullScreen
                        self?.present(tabBarController, animated: true, completion: nil)
                    }
                } else {
                    self?.showMessage(String(describing: error))
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
