//
//  ECHOKeysCoreComponentImp.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 07.10.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import ECHO

final class ECHOKeysCoreComponentImp: ECHOKeysCoreComponent {
    
    var container: AddressKeysContainer?

    func setup(name: String, password: String) throws {
        
        guard let container = AddressKeysContainer(login: name, password: password, core: CryptoCoreImp()) else {
            throw ECHOKeysCoreComponentError.keysGeneration
        }
        self.container = container
    }
    
    func clear() {
        self.container = nil
    }    
    
    func publicKey(type: EWKeyType) throws -> String {
        
        guard let container = self.container else {
            throw ECHOKeysCoreComponentError.setupError
        }
        
        switch type {
        case .active:
            return container.activeKeychain.publicKey().hex
        case .memo:
            return container.memoKeychain.publicKey().hex
        case .owner:
            return container.ownerKeychain.publicKey().hex
        }
    }
    
    func publicAddress(type: EWKeyType) throws -> String {
        
        guard let container = self.container else {
            throw ECHOKeysCoreComponentError.setupError
        }
        
        switch type {
        case .active:
            return container.activeKeychain.publicAddress()
        case .memo:
            return container.memoKeychain.publicAddress()
        case .owner:
            return container.ownerKeychain.publicAddress()
        }
    }
}
