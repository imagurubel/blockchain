//
//  RootRootConfigurator.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 19/03/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit
import Swinject

class RootModuleConfigurator {

    func configureModule () -> RootModuleInput {

        let moduleInput = AppDelegate.moduleAssembly.resolver.resolve(RootModuleInput.self)!
        
        return moduleInput
    }

}
