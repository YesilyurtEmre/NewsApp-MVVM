//
//  CreateAccountVC.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 17.10.2024.
//

import UIKit
import FirebaseAuth

class CreateAccountVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var signUpTitleLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    let createAccountViewModel = CreateAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func configureTextFields() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        nameTextField.setDynamicPlaceholder("Adınızı girin")
        emailTextField.setDynamicPlaceholder("E-posta adresinizi girin")
        passwordTextField.setDynamicPlaceholder("Şifrenizi girin")
        confirmPasswordTextField.setDynamicPlaceholder("Şifrenizi tekrar girin")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        let validation = createAccountViewModel.validateFields(
            email: emailTextField.text,
            password: passwordTextField.text,
            confirmPassword: confirmPasswordTextField.text
        )
        
        guard validation.isValid else {
            showMessage(validation.errorMessage ?? Constants.loginError)
            return
        }
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        createAccountViewModel.createAccount(email: email, password: password) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    self?.showMessage(Constants.registrationSuccess)
                } else {
                    self?.showMessage(message ?? Constants.loginError)
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
