//
//  DoorsError.swift
//  DoorChain
//
//  Created by Евгения Григорович on 10/4/18.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Foundation

enum ContractError: Swift.Error, Equatable {
    
    case cantGetValue
}

enum DoorsAuthError: Swift.Error, Equatable {
    
    /// Indicates that included account already exists
    case accountAlreadyExists
    
    /// Indicates that removed account doesnt exist
    case accountDoesntExist
    
    /// Indicates that network doesnt exist
    case networkDoesntExist
    
    /// Indicates that included network already exists
    case networkAlreadyExists
    
    /// Indicates attempt to delete all networks
    case emptyNetworks
    
    /// Indicates faucet registration failed
    case faucetRegistration
    
    /// Indicates that credentials dont exist
    case unavailableLogin
    
    /// Indicates that node is unavailable
    case accessNode
    
    /// Indicates that application in suspended state
    case suspendedState
}

enum DoorChainFrameworkError: Swift.Error, Equatable {
    
    /// Indicates connection to node or revial api from this node failed
    case setupFailed
    
    /// Indicates that u shoud start lib at first and the call methods as normal
    case setupRequire
    
    /// Indicates that credentials is invalid
    case invalidCredentials
    
    /// Indicates that connection to the node failed
    case connectionFaild
    
    /// Indicates error inside framework
    case innerError
}
