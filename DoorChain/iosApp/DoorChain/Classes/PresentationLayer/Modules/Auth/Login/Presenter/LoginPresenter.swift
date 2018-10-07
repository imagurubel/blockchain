//
//  LoginLoginPresenter.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

class LoginPresenter {

    weak var view: LoginViewInput!
    weak var output: LoginModuleOutput?
    
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
}

// MARK: - LoginModuleInput

extension LoginPresenter: LoginModuleInput {

  	var viewController: UIViewController {
    	return view.viewController
  	}

}

// MARK: - LoginViewOutput

extension LoginPresenter: LoginViewOutput {

    func viewIsReady() {

    }
    
    func registrationAction() {
        output?.actionShowRegistration()
    }
    
    func loginAction(login: String?, password: String?) {
        
        guard let login = login,
            let password = password else {
            view.showNoValues(message: "Enter values")
            return
        }
        
        interactor.login(login: login, password: password)
    }
}

// MARK: - LoginInteractorOutput

extension LoginPresenter: LoginInteractorOutput {

    func loadingStart() {
        view.showLoading()
    }
    
    func loadingEnd() {
        view.hideLoading()
    }
    
    func loginSuccess() {
        output?.actionDidLogin()
    }
    
    func loginFailure(message: String) {
        view.showError(message: message)
    }
}
