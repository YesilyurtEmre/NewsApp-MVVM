//
//  CreateAccountVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import UIKit
import FirebaseAuth

class CreateAccountVC: UIViewController {
    @IBOutlet weak var signUpTitleLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    let createAccountViewModel = CreateAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showMessage(String.requiredFields)
            return
        }
        
        guard password == confirmPassword else {
            showMessage(String.passwordMismatch)
            return
        }
        
        createAccountViewModel.createAccount(email: email, password: password) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    self?.showMessage(String.registrationSuccess)
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    self?.showMessage(message ?? String.loginError)
                }
            }
        }
    }
    
    private func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}
