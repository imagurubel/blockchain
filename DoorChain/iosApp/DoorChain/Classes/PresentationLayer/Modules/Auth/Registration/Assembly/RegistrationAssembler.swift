//
//  RegistrationRegistrationAssembler.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit
import Swinject

class RegistrationModuleAssembler: Assembly {
    
    func assemble(container: Container) {

        container.register(RegistrationInteractor.self) { (resolver, presenter: RegistrationPresenter) in

            let interactor = RegistrationInteractor()
            interactor.output = presenter
            interactor.authFacade = resolver.resolve(AuthFacadeService.self)
            
            return interactor
        }
        
        container.register(RegistrationRouter.self) { (_, viewController: RegistrationViewController) in

            let router = RegistrationRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(RegistrationModuleInput.self) { resolver in

            let presenter = RegistrationPresenter()

            let viewController = resolver.resolve(RegistrationViewController.self, argument: presenter)!

            presenter.view = viewController
            presenter.interactor = resolver.resolve(RegistrationInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(RegistrationRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(RegistrationViewController.self) { (_, presenter: RegistrationPresenter) in

            let viewController = R.storyboard.auth.registrationViewController()!
            viewController.output = presenter
            return viewController
        }
    }
}
