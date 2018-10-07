//
//  RegistrationRegistrationProtocols.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

protocol RegistrationViewInput: class, Presentable {

    func setupInitialState()
    func showLoginNotValid(message: String)
    func showPasswordNotValid(message: String)
    func showConfrimPasswordNotValid(message: String)
    func showNoValues(message: String)
    func showError(message: String)
    func showLoading()
    func hideLoadring()
}

protocol RegistrationViewOutput {

    func viewIsReady()
    func loginAction()
    func registration(login: String?, password: String?, confirmPassword: String?)
}

protocol RegistrationModuleInput: class {

	var viewController: UIViewController { get }
	var output: RegistrationModuleOutput? { get set }
}

protocol RegistrationModuleOutput: class {

    func actionShowLogin()
    func actionDidRegistered()
}

protocol RegistrationInteractorInput {

    func register(login: String, password: String)
}

protocol RegistrationInteractorOutput: class {
    
    func loadingStart()
    func loadingEnd()
    func registeredWithError(error: String)
    func registeredSuccess()
}

protocol RegistrationRouterInput {

}
