//
//  DoorsDoorsProtocols.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 06/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

protocol DoorsViewInput: class, Presentable {

    func setupInitialState(doors: [Door], isOwner: Bool)
    func showLoading()
    func hideLoading()
    func showError(message: String)
}

protocol DoorsViewOutput {

    func viewIsReady()
    func actionLoadData()
    func actionOpenDoor(door: Door)
    func actionEditDoor()
    func actionDeleteDoor(door: Door)
}

protocol DoorsModuleInput: class {

	var viewController: UIViewController { get }
	var output: DoorsModuleOutput? { get set }
}

protocol DoorsModuleOutput: class {

}

protocol DoorsInteractorInput {
    
    func getData() -> ([Door], Bool)
    func loadData()
    func openDoor(door: Door)
}

protocol DoorsInteractorOutput: class {
    
    func dataLoaded()
    func showError(message: String)
    func loadingStarted()
    func loadingEnded()
}

protocol DoorsRouterInput {

}
