//
//  LoginLoginProtocols.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

protocol LoginViewInput: class, Presentable {

    func setupInitialState()
    func showLoginNotValid(message: String)
    func showPasswordNotValid(message: String)
    func showLoginOrPasswordNotValid(message: String)
    func showNoValues(message: String)
    func showError(message: String)
    func showLoading()
    func hideLoading()
}

protocol LoginViewOutput {

    func viewIsReady()
    func registrationAction()
    func loginAction(login: String?, password: String?)
}

protocol LoginModuleInput: class {

	var viewController: UIViewController { get }
	var output: LoginModuleOutput? { get set }
}

protocol LoginModuleOutput: class {

    func actionShowRegistration()
    func actionDidLogin()
}

protocol LoginInteractorInput {
  
    func login(login: String, password: String)
}

protocol LoginInteractorOutput: class {
    
    func loadingStart()
    func loadingEnd()
    func loginSuccess()
    func loginFailure(message: String)
}

protocol LoginRouterInput {

}
