//
//  RootRootPresenter.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 19/03/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

enum AuthState {
    case unauth
    case varification
    case auth
}

class RootPresenter {

    weak var view: RootViewInput!
    weak var output: RootModuleOutput?
    
    var interactor: RootInteractorInput!
    var router: RootRouterInput!
}

// MARK: - RootModuleInput

extension RootPresenter: RootModuleInput {

  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - RootViewOutput

extension RootPresenter: RootViewOutput {
    
    func viewIsReady() {
        interactor.setupEchoLib()
    }
    
    func viewPresented() {
        router.presentLogin(output: self)
    }
}

// MARK: - RootInteractorOutput

extension RootPresenter: RootInteractorOutput {
    
}

extension RootPresenter: LoginModuleOutput {
    
    func actionShowRegistration() {
        router.presentRegistration(output: self)
    }
    
    func actionDidLogin() {
        router.presentDoorsScrren()
    }
}

extension RootPresenter: RegistrationModuleOutput {
    
    func actionShowLogin() {
        router.presentLogin(output: self)
    }
    
    func actionDidRegistered() {
        router.presentDoorsScrren()
    }
}
