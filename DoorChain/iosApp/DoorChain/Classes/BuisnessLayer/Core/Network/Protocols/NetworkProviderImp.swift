//
//  NetworkProviderImp.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 14.01.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Moya
import Alamofire

class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

enum FaucetApi {
    case register(account: String, ownerKey: String, activeKey: String, memoKey: String)
}

extension FaucetApi: TargetType {
    
    var baseURL: URL { return URL(string: "https://echo-tmp-wallet.pixelplex.io/faucet")! }
    var path: String {
        switch self {
            
        case .register(_, _, _, _):
            return "/registration"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        }
    }
    
    var task: Task {
        switch self {
            
        case let .register(account, ownerKey, activeKey, memoKey):
            return .requestParameters(parameters: ["name": account,
                                                   "owner_key": ownerKey,
                                                   "active_key": activeKey,
                                                   "memo_key": memoKey], encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }

}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
