//
//  DoorsDoorsConfigurator.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 06/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit
import Swinject

class DoorsModuleConfigurator {

    func configureModule () -> DoorsModuleInput {

        let moduleInput = AppDelegate.moduleAssembly.resolver.resolve(DoorsModuleInput.self)!
        
        return moduleInput
    }
}
