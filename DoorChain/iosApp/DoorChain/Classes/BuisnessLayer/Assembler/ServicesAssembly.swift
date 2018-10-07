//
//  ServicesAssembly.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 17.05.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Swinject
import ECHO

final class ServicesAssembly: Assembly {

    func assemble(container: Container) {
        
        container.register(AuthFacadeService.self) {resolver in
            
            let service = AuthFacadeServiceImp()
            service.faucetCoreComponent = resolver.resolve(FaucetNetworkCoreComponent.self)
            service.keysCoreComponent = resolver.resolve(ECHOKeysCoreComponent.self)
            service.echo = resolver.resolve(ECHO.self)
            
            return service
        }.inObjectScope(.container)
        
        container.register(ContractService.self) {resolver in
            
            let service = ContractSerivceImp()
            service.echo = resolver.resolve(ECHO.self)
            
            return service
        }.inObjectScope(.container)
        
        container.register(ECHO.self) {_ in
            
            let echo = ECHO(settings: Settings(build: {
                $0.apiOptions = [.accountHistory, .database, .networkBroadcast]
            }))

            return echo
        }.inObjectScope(.container)
    }
}
