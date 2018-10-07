//
//  CoreComponentAssembly.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 17.05.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Swinject

final class CoreComponentAssembly: Assembly {
        
    func assemble(container: Container) {
        
        container.register(FaucetNetworkCoreComponent.self) {_ in
            
            let service = FaucetNetworkCoreComponentImp()
            
            return service
        }.inObjectScope(.container)
        
        container.register(ECHOKeysCoreComponent.self) {_ in
            
            let service = ECHOKeysCoreComponentImp()
            
            return service
        }.inObjectScope(.container)
    }
}
