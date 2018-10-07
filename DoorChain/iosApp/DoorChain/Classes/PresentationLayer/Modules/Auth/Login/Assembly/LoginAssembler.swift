//
//  LoginLoginAssembler.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit
import Swinject

class LoginModuleAssembler: Assembly {
    
    func assemble(container: Container) {

        container.register(LoginInteractor.self) { (resolver, presenter: LoginPresenter) in

            let interactor = LoginInteractor()
            interactor.output = presenter
            interactor.authFacade = resolver.resolve(AuthFacadeService.self)
            interactor.contractService = resolver.resolve(ContractService.self)
            
            return interactor
        }
        
        container.register(LoginRouter.self) { (_, viewController: LoginViewController) in

            let router = LoginRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(LoginModuleInput.self) { resolver in

            let presenter = LoginPresenter()

            let viewController = resolver.resolve(LoginViewController.self, argument: presenter)!

            presenter.view = viewController
            presenter.interactor = resolver.resolve(LoginInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(LoginRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(LoginViewController.self) { (_, presenter: LoginPresenter) in

            let viewController = R.storyboard.auth.loginViewController()!
            viewController.output = presenter
            return viewController
        }
    }
}
