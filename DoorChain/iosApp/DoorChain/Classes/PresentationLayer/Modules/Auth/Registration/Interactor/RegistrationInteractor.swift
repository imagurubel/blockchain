//
//  RegistrationRegistrationInteractor.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

class RegistrationInteractor {

    weak var output: RegistrationInteractorOutput!
    var authFacade: AuthFacadeService!
}

// MARK: - RegistrationInteractorInput

extension RegistrationInteractor: RegistrationInteractorInput {
 
    func register(login: String, password: String) {
        
        output.loadingStart()
        authFacade.registration(login: login, password: password) { [weak self] (result) in
            
            self?.output.loadingEnd()
            do {
                let success = try result.dematerialize()
                if success {
                    self?.output.registeredSuccess()
                } else {
                    self?.output.registeredWithError(error: "Some error")
                }
            } catch let error {
                self?.output.registeredWithError(error: error.localizedDescription)
            }
        }
    }
}
