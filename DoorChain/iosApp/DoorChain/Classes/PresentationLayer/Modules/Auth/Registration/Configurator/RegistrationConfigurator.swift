//
//  RegistrationRegistrationConfigurator.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit
import Swinject

class RegistrationModuleConfigurator {

    func configureModule () -> RegistrationModuleInput {

        let moduleInput = AppDelegate.moduleAssembly.resolver.resolve(RegistrationModuleInput.self)!
        
        return moduleInput
    }
}
