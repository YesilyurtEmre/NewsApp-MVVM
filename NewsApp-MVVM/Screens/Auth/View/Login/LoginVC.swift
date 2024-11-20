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
    private var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [emailTextfield, passwordTextfield]
        configureTextFields()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = loginViewModel.nextResponder(for: textField, textFieldOrder: textFields) {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func configureTextFields() {
        let placeholders = loginViewModel.placeholders()
        
        for (index, textField) in textFields.enumerated() {
            textField.delegate = self
            if index < placeholders.count {
                textField.setDynamicPlaceholder(placeholders[index])
            }
        }
        
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
