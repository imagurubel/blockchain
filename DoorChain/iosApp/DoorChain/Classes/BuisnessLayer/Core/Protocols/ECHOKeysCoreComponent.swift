//
//  ECHOKeysCoreComponent.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 07.10.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import ECHO

enum ECHOKeysCoreComponentError: Swift.Error, Equatable {
    
    /// Indicates that keychain is empty, first try to setup component
    case setupError
    
    /// Indicates that generation private key failed
    case keysGeneration
}

public enum EWKeyType: String {
    case owner
    case active
    case memo
}

protocol ECHOKeysCoreComponent: class, Clearable {
    
    func setup(name: String, password: String) throws
    func publicKey(type: EWKeyType) throws -> String
    func publicAddress(type: EWKeyType) throws -> String 
}
