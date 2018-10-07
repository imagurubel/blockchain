//
//  DoorsDoorsAssembler.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 06/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit
import Swinject

class DoorsModuleAssembler: Assembly {
    
    func assemble(container: Container) {

        container.register(DoorsInteractor.self) { (resolver, presenter: DoorsPresenter) in

            let interactor = DoorsInteractor()
            interactor.output = presenter
            interactor.userFacade = resolver.resolve(AuthFacadeService.self)
            interactor.contracts = resolver.resolve(ContractService.self)
            
            return interactor
        }
        
        container.register(DoorsRouter.self) { (_, viewController: DoorsViewController) in

            let router = DoorsRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(DoorsModuleInput.self) { resolver in

            let presenter = DoorsPresenter()

            let viewController = resolver.resolve(DoorsViewController.self, argument: presenter)!

            presenter.view = viewController
            presenter.interactor = resolver.resolve(DoorsInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(DoorsRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(DoorsViewController.self) { (_, presenter: DoorsPresenter) in

            let viewController = R.storyboard.doors.instantiateInitialViewController()!
            viewController.output = presenter
            return viewController
        }
    }
}
