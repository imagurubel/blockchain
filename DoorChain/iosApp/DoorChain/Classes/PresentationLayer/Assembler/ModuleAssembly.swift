//
//  ModuleAssembly.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 13.09.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Swinject

class ModuleAssembly {
    
    fileprivate let assembler: Assembler!
    public var resolver: Resolver {
        return assembler.resolver
    }
    
    init(parent: Assembler) {
        assembler = Assembler([RootModuleAssembler(),
                               LoginModuleAssembler(),
                               RegistrationModuleAssembler(),
                               DoorsModuleAssembler()], parent: parent)
    }
}
