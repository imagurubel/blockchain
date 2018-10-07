//
//  LoginLoginViewController.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    var output: LoginViewOutput!

    var loginTextField: CustomTextFieldWithImage!
    var passwordTextField: CustomTextFieldWithImage!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var notHaveAccountLabel: UILabel!
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loginTextField.setText("vsharaev1")
        passwordTextField.setText("newTestPass")
    }
    
    @IBAction func loginActions(_ sender: Any) {
        
        actionTap(self)
        loginTextField.hideErrorState()
        passwordTextField.hideErrorState()
        output.loginAction(login: loginTextField.getText(), password: passwordTextField.getText())
    }
    
    @IBAction func registrationAction(_ sender: Any) {
        
        output.registrationAction()
    }
    
    @IBAction func actionTap(_ sender: Any) {
        
        loginTextField.textField.resignFirstResponder()
        passwordTextField.textField.resignFirstResponder()
    }
}

// MARK: - Config

extension LoginViewController {
    
    func config() {
        
        configLocalizations()
        configLoginTextField()
        configPasswordTextField()
    }
    
    func configLocalizations() {
        
        titleLabel.text = "Login"
        notHaveAccountLabel.text = "Don't have account"
        loginButton.setTitle("Login", for: .normal)
        registrationButton.setTitle("Registration", for: .normal)
    }
    
    func configLoginTextField() {
        
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

extension LoginViewController {
    
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

// MARK: - CustomTextFieldDelegate

extension LoginViewController: CustomTextFieldDelegate {
    
    func textDidChange(textField: CustomTextField, resultText: String?) {
        
    }
    
    @objc func textFieldDidBeginEditing(textField: CustomTextField) {
        
    }
}

// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {
  
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
    
    func showLoginOrPasswordNotValid(message: String) {
        
        showErrorMessage(message: message)
        loginTextField.startEditing()
        loginTextField.showErrorState()
        passwordTextField.showErrorState()
    }
    
    func showNoValues(message: String) {
        
        showErrorMessage(message: message)
        loginTextField.startEditing()
        passwordTextField.showErrorState()
        loginTextField.showErrorState()
    }
    
    func showError(message: String) {
        
        showErrorMessage(message: message)
    }
    
    func showLoading() {
        
        showLoader()
    }
    
    func hideLoading() {
        
        hideLoader()
    }
}
