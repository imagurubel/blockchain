//
//  RootRootAssembler.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 19/03/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit
import Swinject
import ECHO

class RootModuleAssembler: Assembly {
    
    func assemble(container: Container) {

        container.register(RootInteractor.self) { ( resolver, presenter: RootPresenter) in

            let interactor = RootInteractor()
            interactor.output = presenter
            interactor.echo = resolver.resolve(ECHO.self)

            return interactor
        }
        
        container.register(RootRouter.self) { (_, viewController: RootViewController) in

            let router = RootRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(RootModuleInput.self) { resolver in

            let presenter = RootPresenter()

            let viewController = resolver.resolve(RootViewController.self, argument: presenter)!

            presenter.view = viewController
            presenter.interactor = resolver.resolve(RootInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(RootRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(RootViewController.self) { (_, presenter: RootPresenter) in

            let viewController = R.storyboard.root.rootViewController()!
            viewController.output = presenter
            return viewController
        }
    }
}
