//
//  AuthFacadeServiceImp.swift
//  DoorChain
//
//  Created by Евгения Григорович on 10/4/18.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Foundation
import ECHO

final class AuthFacadeServiceImp: AuthFacadeService {
    
    var faucetCoreComponent: FaucetNetworkCoreComponent!
    var keysCoreComponent: ECHOKeysCoreComponent!
    var echo: ECHO!
    
    var login: String?
    var password: String?
    var identifier: String?
    
    func getLogin() -> String? {
        return login
    }
    
    func getPassword() -> String? {
        return password
    }
    
    func getIdentifier() -> String? {
        return identifier
    }
    
    func checkLogin(completionBlock: @escaping (() throws -> Bool) -> ()) {
        
    }
    
    func login(login: String, password: String, completionBlock: @escaping AuthCompletionHndler<Bool>) {
        
        echo.isOwnedBy(name: login, password: password) { [weak self] (result) in
            
            do {
                let account = try result.dematerialize()
                self?.identifier = account.account.id
                self?.login = login
                self?.password = password
                let result = ResultHandler<Bool, DoorsAuthError>(value: true)
                completionBlock(result)
                print("Login success")
            } catch {
                let result = ResultHandler<Bool, DoorsAuthError>(error: DoorsAuthError.unavailableLogin)
                completionBlock(result)
            }
        }
    }
    
    func registration(login: String, password: String, completionBlock: @escaping AuthCompletionHndler<Bool>) {
        
        guard let _ = try? keysCoreComponent.setup(name: login, password: password),
            var ownerKey = try? keysCoreComponent.publicAddress(type: .owner),
            var activeKey = try? keysCoreComponent.publicAddress(type: .active),
            var memoKey = try? keysCoreComponent.publicAddress(type: .memo) else {
                
                let result = ResultHandler<Bool, DoorsAuthError>(error: DoorsAuthError.faucetRegistration)
                completionBlock(result)
                return
        }
        
        let prefix = Constants.keysPrefix
        
        ownerKey = prefix + ownerKey
        memoKey = prefix + memoKey
        activeKey = prefix + activeKey
        
        keysCoreComponent.clear()
        
        faucetCoreComponent.register(account: login, ownerKey: ownerKey, activeKey: activeKey, memoKey: memoKey) { [weak self] (result) in
            
            do {
                let res = try result.dematerialize()
                print("After registration data: \(res)")
                self?.login = login
                self?.password = password
                self?.identifier = res
                let result = ResultHandler<Bool, DoorsAuthError>(value: true)
                completionBlock(result)
            } catch DoorChainFrameworkError.invalidCredentials {
                let result = ResultHandler<Bool, DoorsAuthError>(error: .accountAlreadyExists)
                completionBlock(result)
            } catch is DoorChainFrameworkError {
                let result = ResultHandler<Bool, DoorsAuthError>(error: .accessNode)
                completionBlock(result)
            } catch let error as DoorsAuthError {
                let result = ResultHandler<Bool, DoorsAuthError>(error: error)
                completionBlock(result)
            } catch {
                let result = ResultHandler<Bool, DoorsAuthError>(error: .unavailableLogin)
                completionBlock(result)
            }
        }
    }
}
