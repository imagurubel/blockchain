//
//  RootRootRouter.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 19/03/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

class RootRouter: RootRouterInput {
    
	weak var view: UIViewController?
    weak var authView: UIViewController?

    var childs = NSPointerArray.weakObjects()
}

extension RootRouter {
    
    func presentLogin(output: LoginModuleOutput) {

        let loginModule = LoginModuleConfigurator().configureModule()
        loginModule.output = output
        presentAuth(viewController: loginModule.viewController)
    }
    
    func presentMainScreen() {
        
        
    }
    
    func presentRegistration(output: RegistrationModuleOutput) {
        
        let registrationModule = RegistrationModuleConfigurator().configureModule()
        registrationModule.output = output
        presentAuth(viewController: registrationModule.viewController)
    }
    
    fileprivate func presentAuth(viewController: UIViewController!) {
        
        viewController.modalPresentationStyle = .overFullScreen
        
        guard let view = self.view else {
            return
        }
        
        if authView == nil {
            
            authView = viewController
            view.present(viewController, animated: true, completion: nil)
        } else {
            authView?.dismiss(animated: true) {
                
                self.authView = viewController
                view.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    func presentDoorsScrren() {
        
        guard let view = view else {
            return
        }
        
        let doorsModule = DoorsModuleConfigurator().configureModule()
        let navController = UINavigationController()
        navController.setViewControllers([doorsModule.viewController], animated: false)
        navController.navigationBar.barTintColor = R.clr.doorChain.blueTabs()
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                           NSAttributedStringKey.font: R.font.geometriaMedium(size: 20)!]
        
        if let authView = authView {
            authView.dismiss(animated: true) {
                view.present(navController, animated: false, completion: nil)
            }
        } else {
            view.present(navController, animated: false, completion: nil)
        }
    }
}
