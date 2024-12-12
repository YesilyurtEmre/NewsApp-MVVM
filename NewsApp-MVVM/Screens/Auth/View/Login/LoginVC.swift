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
    
    private lazy var loginViewModel = LoginViewModel()
    private var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [emailTextfield, passwordTextfield]
        loginViewModel.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        configureTextFields()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func placeholders() -> [String] {
        return [
            "E-posta adresinizi girin",
            "Şifrenizi girin"
        ]
    }
    
    //Move to VM
    private func configureTextFields() {
        let placeholders = placeholders()
        
        for (index, textField) in textFields.enumerated() {
            textField.delegate = self
            if index < placeholders.count {
                textField.setDynamicPlaceholder(placeholders[index])
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return loginViewModel.textFieldShouldReturn(textField, textFieldOrder: textFields)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let email = emailTextfield.text
        let password = passwordTextfield.text
        loginViewModel.handleLogin(email: email, password: password)
    }
    
    // TODO: - Move to VM
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: Constants.StoryboardIdentifiers.createAccountStoryboard, bundle: nil)
        if let createAccountVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.createAccountVC) as? CreateAccountVC {
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

extension LoginVC: LoginViewModelDelegate {
    
    func didLoginSuccessfully() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: Constants.StoryboardIdentifiers.mainStoryboard, bundle: nil)
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.tabBarController) as? UITabBarController {
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true, completion: nil)
            }
        }
    }
    
    func didFailToLogin(error: String) {
        DispatchQueue.main.async {
            self.showMessage(error)
        }
    }
}

