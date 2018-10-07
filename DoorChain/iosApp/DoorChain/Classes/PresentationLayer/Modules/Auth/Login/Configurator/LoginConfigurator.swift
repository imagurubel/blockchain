//
//  LoginLoginConfigurator.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit
import Swinject

class LoginModuleConfigurator {

    func configureModule () -> LoginModuleInput {

        let moduleInput = AppDelegate.moduleAssembly.resolver.resolve(LoginModuleInput.self)!
        
        return moduleInput
    }
}
