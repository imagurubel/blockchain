//
//  RegistrationRegistrationViewController.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    var output: RegistrationViewOutput!
    
    var loginTextField: CustomTextFieldWithImage!
    var passwordTextField: CustomTextFieldWithImage!
    var confirmPasswordTextField: CustomTextFieldWithImage!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var confirmpasswordContainer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        output.loginAction()
    }
    
    @IBAction func registrationAction(_ sender: Any) {
        
        loginTextField.hideErrorState()
        passwordTextField.hideErrorState()
        confirmPasswordTextField.hideErrorState()
        
        let login = loginTextField.getText()
        let password = passwordTextField.getText()
        let confrimPassword = confirmPasswordTextField.getText()
        
        actionTap(self)
        output.registration(login: login, password: password, confirmPassword: confrimPassword)
    }
    
    @IBAction func actionTap(_ sender: Any) {
        
        loginTextField.textField.resignFirstResponder()
        passwordTextField.textField.resignFirstResponder()
        confirmPasswordTextField.textField.resignFirstResponder()
    }
}

// MARK: - Config

extension RegistrationViewController {
    
    func config() {
        
        configLocalizations()
        configloginTextField()
        configPasswordTextField()
        configConfirmPasswordTextField()
    }
    
    func configLocalizations() {
        
        titleLabel.text = "Registration"
        haveAccountLabel.text = "You have account"
        loginButton.setTitle("login", for: .normal)
        registrationButton.setTitle("Registration", for: .normal)
    }
    
    func configloginTextField() {
        
        let textField = R.nib.customTextFieldWithImage.firstView(owner: nil)!
        loginTextField = textField
        textField.setKeyboardType(.emailAddress)
        textField.delegate = self
        textField.setPlacehodlerText("Login")
//        textField.setImage(R.image.icUser())
        
        adddViewToContainer(view: textField, container: emailContainer)
    }
    
    func configPasswordTextField() {
        
        let textField = R.nib.customTextFieldWithImage.firstView(owner: nil)!
        passwordTextField = textField
        textField.textField.isSecureTextEntry = true
        textField.delegate = self
        textField.setPlacehodlerText("Password")
//        textField.setImage(R.image.icPassword())
        
        adddViewToContainer(view: textField, container: passwordContainer)
    }
    
    func configConfirmPasswordTextField() {
        
        let textField = R.nib.customTextFieldWithImage.firstView(owner: nil)!
        confirmPasswordTextField = textField
        textField.textField.isSecureTextEntry = true
        textField.delegate = self
        textField.setPlacehodlerText("Confirm password")
//        textField.setImage(R.image.icPassword())
        
        adddViewToContainer(view: textField, container: confirmpasswordContainer)
    }
    
    func adddViewToContainer(view: UIView, container: UIView) {
        
        container.addSubview(view)
        container.backgroundColor = UIColor.clear
        
        view.snp.makeConstraints { (make) in
            make.left.equalTo(container.snp.left).offset(0)
            make.right.equalTo(container.snp.right).offset(0)
            make.bottom.equalTo(container.snp.bottom).offset(0)
            make.top.equalTo(container.snp.top).offset(0)
        }
    }
}

// MARK: - Errors

extension RegistrationViewController {
    
    func showErrorMessage(message: String) {
        
        errorLabel.text = message
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.alpha = 1
        }) { (_) in
            self.hideErrorMessage()
        }
    }
    
    func hideErrorMessage() {
        
        UIView.animate(withDuration: 0.3, delay: 2, options: .curveLinear, animations: {
            self.errorLabel.alpha = 0
        }, completion: nil)
    }
}

// MARK: - RegistrationViewInput

extension RegistrationViewController: RegistrationViewInput {
  
	func setupInitialState() {
    
  	}
    
    func showLoginNotValid(message: String) {
        
        showErrorMessage(message: message)
        loginTextField.startEditing()
        loginTextField.showErrorState()
    }
    
    func showPasswordNotValid(message: String) {
        
        showErrorMessage(message: message)
        passwordTextField.startEditing()
        passwordTextField.showErrorState()
    }
    
    func showConfrimPasswordNotValid(message: String) {
        
        showErrorMessage(message: message)
        passwordTextField.startEditing()
        passwordTextField.showErrorState()
        confirmPasswordTextField.showErrorState()
    }
    
    func showNoValues(message: String) {
        
        showErrorMessage(message: message)
        loginTextField.startEditing()
        loginTextField.showErrorState()
        passwordTextField.showErrorState()
        confirmPasswordTextField.showErrorState()
    }
    
    func showError(message: String) {
        
        showErrorMessage(message: message)
    }
    
    func showLoading() {
        showLoader()
    }
    
    func hideLoadring() {
        hideLoader()
    }
}

// MARK: - CustomTextFieldDelegate

extension RegistrationViewController: CustomTextFieldDelegate {
    
    func textDidChange(textField: CustomTextField, resultText: String?) {
        
    }
    
    @objc func textFieldDidBeginEditing(textField: CustomTextField) {
        
    }
    
    
    @objc func returnDidTap(textField: CustomTextField) {

    }
}
