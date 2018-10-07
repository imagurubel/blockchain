//
//  AuthFacadeService.swift
//  DoorChain
//
//  Created by Евгения Григорович on 10/4/18.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Foundation
import ECHO

typealias AuthCompletionHndler<T> = (_ result: ResultHandler<T, DoorsAuthError>) -> Void

protocol AuthFacadeService {
    
    func getLogin() -> String?
    func getPassword() -> String?
    func getIdentifier() -> String?
    
    func checkLogin(completionBlock: @escaping (() throws -> Bool) -> ())
    func login(login: String, password: String, completionBlock: @escaping AuthCompletionHndler<Bool>)
    func registration(login: String, password: String, completionBlock: @escaping AuthCompletionHndler<Bool>)
}
