//
//  FaucetNetworkCore.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 07.10.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import SwiftyJSON

protocol FaucetNetworkCoreComponent {
    
    func register(account: String, ownerKey: String, activeKey: String, memoKey: String, completion: @escaping AuthCompletionHndler<String>)
}
