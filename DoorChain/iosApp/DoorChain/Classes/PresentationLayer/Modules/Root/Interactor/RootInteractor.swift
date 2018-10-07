//
//  RootRootInteractor.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 19/03/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import ECHO

class RootInteractor {

    weak var output: RootInteractorOutput!
    var echo: ECHO!
}

// MARK: - RootInteractorInput

extension RootInteractor: RootInteractorInput {
    
    func setupEchoLib() {
        
        echo.start { [weak self] (result) in
            switch result {
            case .success(_):
                print("Echo started")
            case .failure(_):
                print("Echo not started")
                self?.setupEchoLib()
            }
        }
    }
}
