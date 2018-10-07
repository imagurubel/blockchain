//
//  LoginLoginInteractor.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

class LoginInteractor {

    weak var output: LoginInteractorOutput!
    var authFacade: AuthFacadeService!
    var contractService: ContractService!
}

// MARK: - LoginInteractorInput

extension LoginInteractor: LoginInteractorInput {
 
    func login(login: String, password: String) {
        
        output.loadingStart()
        authFacade.login(login: login, password: password) { [weak self] (result) in
            
            self?.output.loadingEnd()
            do {
                _ = try result.dematerialize()
                self?.output.loginSuccess()
                
//                guard let login = self?.authFacade.getLogin() else { return }
//                guard let pass = self?.authFacade.getPassword() else { return }
//
//                self?.contractService.getDoorsCount(login: login, completionBlock: { (result) in
//                    print("getDoorsCount: \(result)")
//                })
//
//                self?.contractService.getDoorInfoByIndex(login: login,
//                                                         index: 1,
//                                                         completionBlock: { (result) in
//                    print("getDoorInfoByIndex: \(result)")
//                })
//
//                self?.contractService.getDoorInfoByIdintifier(login: login,
//                                                              identifier: 2,
//                                                              completionBlock: { (result) in
//                    print("getDoorInfoByIdintifier: \(result)")
//                })
//
//                self?.contractService.isOwner(login: login, completionBlock: { (result) in
//                    print("isOwner: \(result)")
//                })
//
//                self?.contractService.openDoor(login: "vsharaev6",
//                                               password: "P5Jhsw5ugUZ8kn715WTLeo3m4obP1Dgdjwr5Mpa176WxU",
//                                               identifier: 1,
//                                               completionBlock: { (result) in
//                    print("openDoor: \(result)")
//                })
                
//                self?.contractService.addDoor(login: login,
//                                              password: password,
//                                              identifier: 1,
//                                              name: "Vova1",
//                                              completionBlock: { (result) in
//                    print("addDoor: \(result)")
//                })
                
//                self?.contractService.removeDoor(login: login,
//                                                 password: pass,
//                                                 identifier: 1,
//                                                 completionBlock: { (result) in
//                    print("removeDoor: \(result)")
//                })
                
//                self?.contractService.addUserToDoor(login: login,
//                                                    password: pass,
//                                                    doorId: 13,
//                                                    userId: "1.2.22",
//                                                    completionBlock: { (result) in
//                    print("addUserToDoor: \(result)")
//                })
                
//                self?.contractService.removeUserFromDoor(login: login,
//                                                         password: password,
//                                                         doorId: 14,
//                                                         userId: "1.2.22",
//                                                         completionBlock: { (result) in
//                    print("removeUserFromDoor: \(result)")
//                })
                
//                self?.contractService.getDoorWhiteList(login: login,
//                                                       doorId: 20,
//                                                       completionBlock: { (result) in
//                    print("getDoorWhiteList: \(result)")
//                })
            } catch {
                self?.output.loginFailure(message: "Invalid credentials")
            }
        }
        
        
    }
}
