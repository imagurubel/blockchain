//
//  FaucetNetworkImp.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 07.10.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Moya
import SwiftyJSON
import ECHO

final class FaucetNetworkCoreComponentImp: FaucetNetworkCoreComponent {
    
    var provider = MoyaProvider<FaucetApi>(manager: DefaultAlamofireManager.sharedManager)
    
    func register(account: String, ownerKey: String, activeKey: String, memoKey: String, completion: @escaping AuthCompletionHndler<String>) {
        
        provider.request(.register(account: account, ownerKey: ownerKey, activeKey: activeKey, memoKey: memoKey)) { [weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case let .success(moyaResponse):
                
                do {
                    let data = moyaResponse.data
                    let json = try JSON(data: data)
                    let outputs = try strongSelf.mapResult(json: json)
                    let result = ResultHandler<String, DoorsAuthError>(value: outputs)
                    completion(result)
                } catch let error as DoorsAuthError {
                    let result = ResultHandler<String, DoorsAuthError>(error: error)
                    completion(result)
                } catch {
                    let result = ResultHandler<String, DoorsAuthError>(error: DoorsAuthError.faucetRegistration)
                    completion(result)
                }
            case .failure:
                let result = ResultHandler<String, DoorsAuthError>(error: DoorsAuthError.faucetRegistration)
                completion(result)
            }
        }
    }
}

extension FaucetNetworkCoreComponentImp {
    
    func mapResult(json: JSON) throws -> String {
        
        let id = json.array?.first?.dictionary?["trx"]?.dictionary?["operation_results"]?.array?.first?.array?[1].string

        if let id = id {
            return id
        }
        
        if let _ = json["name"].array {
            throw DoorsAuthError.accountAlreadyExists
        } else {
            throw DoorsAuthError.faucetRegistration
        }
    }
}
