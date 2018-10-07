//
//  ContractService.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 06/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Foundation

typealias ContractCompletionHndler<T> = (_ result: ResultHandler<T, ContractError>) -> Void

protocol ContractService {
    
    func getDoorsCount(login: String, completionBlock: @escaping ContractCompletionHndler<Int>)
    func getDoorInfoByIndex(login: String,
                            index: Int,
                            completionBlock: @escaping ContractCompletionHndler<Door>)
    func getDoorInfoByIdintifier(login: String,
                                 identifier: Int,
                                 completionBlock: @escaping ContractCompletionHndler<Door>)
    func isOwner(login: String, completionBlock: @escaping ContractCompletionHndler<Bool>)
    func openDoor(login: String,
                  password: String,
                  identifier: Int,
                  completionBlock: @escaping ContractCompletionHndler<Bool>)
    
    func addDoor(login: String,
                 password: String,
                 identifier: Int,
                 name: String,
                 completionBlock: @escaping ContractCompletionHndler<Bool>)
    
    func removeDoor(login: String,
                    password: String,
                    identifier: Int,
                    completionBlock: @escaping ContractCompletionHndler<Bool>)
    
    func addUserToDoor(login: String,
                       password: String,
                       doorId: Int,
                       userId: String,
                       completionBlock: @escaping ContractCompletionHndler<Bool>)
    
    func removeUserFromDoor(login: String,
                            password: String,
                            doorId: Int,
                            userId: String,
                            completionBlock: @escaping ContractCompletionHndler<Bool>)
    
    func getDoorWhiteList(login: String,
                          doorId: Int,
                          completionBlock: @escaping ContractCompletionHndler<[String]>)
}
