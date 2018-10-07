//
//  DoorsDoorsPresenter.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 06/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

class DoorsPresenter {

    weak var view: DoorsViewInput!
    weak var output: DoorsModuleOutput?
    
    var interactor: DoorsInteractorInput!
    var router: DoorsRouterInput!
}

// MARK: - DoorsModuleInput

extension DoorsPresenter: DoorsModuleInput {

  	var viewController: UIViewController {
    	return view.viewController
  	}

}

// MARK: - DoorsViewOutput

extension DoorsPresenter: DoorsViewOutput {

    func viewIsReady() {
        self.dataLoaded()
        interactor.loadData()
    }
    
    func actionEditDoor() {
        
    }
    
    func actionLoadData() {
        interactor.loadData()
    }
    
    func actionOpenDoor(door: Door) {
        interactor.openDoor(door: door)
    }
    
    func actionDeleteDoor(door: Door) {
        
    }
}

// MARK: - DoorsInteractorOutput

extension DoorsPresenter: DoorsInteractorOutput {
    
    func dataLoaded() {
        let data = interactor.getData()
        view.setupInitialState(doors: data.0, isOwner: data.1)
    }
    
    func showError(message: String) {
        view.showError(message: message)
    }
    
    func loadingStarted() {
        view.showLoading()
    }
    
    func loadingEnded() {
        view.hideLoading()
    }
}
