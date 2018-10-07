//
//  RootRootProtocols.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 19/03/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

protocol RootViewInput: class, Presentable {

    func setupInitialState()
}

protocol RootViewOutput {

    func viewIsReady()
    func viewPresented()
}

protocol RootModuleInput: class {

	var viewController: UIViewController { get }
	var output: RootModuleOutput? { get set }
}

protocol RootModuleOutput: class {

}

protocol RootInteractorInput {
    
    func setupEchoLib()
}

protocol RootInteractorOutput: class {
}

protocol RootRouterInput {
    
    func presentLogin(output: LoginModuleOutput)
    func presentRegistration(output: RegistrationModuleOutput)
    func presentMainScreen()
    func presentDoorsScrren()
}
