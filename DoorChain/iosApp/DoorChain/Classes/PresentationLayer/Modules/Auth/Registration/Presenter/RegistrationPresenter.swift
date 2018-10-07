//
//  RegistrationRegistrationPresenter.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

class RegistrationPresenter {

    weak var view: RegistrationViewInput!
    weak var output: RegistrationModuleOutput?
    
    var interactor: RegistrationInteractorInput!
    var router: RegistrationRouterInput!
}

// MARK: - RegistrationModuleInput

extension RegistrationPresenter: RegistrationModuleInput {

  	var viewController: UIViewController {
    	return view.viewController
  	}

}

// MARK: - RegistrationViewOutput

extension RegistrationPresenter: RegistrationViewOutput {
    
    func viewIsReady() {

    }

    func loginAction() {
        output?.actionShowLogin()
    }
    
    func registration(login: String?, password: String?, confirmPassword: String?) {
        
        guard let login = login,
            let password = password,
            let confirmPassword = confirmPassword else {
                
            view.showNoValues(message: "Enter all values!")
                return
        }
        
        if password != confirmPassword {
            view.showConfrimPasswordNotValid(message: "Confirm passwod not valid")
            return
        }
        
        interactor.register(login: login, password: password)
    }
}

// MARK: - RegistrationInteractorOutput

extension RegistrationPresenter: RegistrationInteractorOutput {
    
    func registeredWithError(error: String) {
        view.showError(message: error)
    }
    
    func registeredSuccess() {
        output?.actionDidRegistered()
    }
    
    func loadingEnd() {
        view.hideLoadring()
    }
    
    func loadingStart() {
        view.showLoading()
    }
}
