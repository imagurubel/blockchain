//
//  ContractSerivceImp.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 06/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Foundation
import ECHO

struct Door {
    let identifier: Int
    let name: String
    
    init(identifier: Int, name: String) {
        self.identifier = identifier
        self.name = name
    }
}

class ContractSerivceImp: ContractService {
    
    var echo: ECHO!
    
    let contractId = "1.16.16186"
    let assetId = "1.3.0"
    
    func getDoorsCount(login: String, completionBlock: @escaping ContractCompletionHndler<Int>) {
        
        echo.queryContract(registrarNameOrId: login,
                           assetId: assetId,
                           contratId: contractId,
                           methodName: "doorsCount", methodParams: []) { (result) in
            
            do {
                let message = try result.dematerialize()
                
                let decoder = AbiArgumentCoderImp()
                let functionEntry = AbiFunctionEntries(name: "result", typeString: "int256", type: .int(size: 256))
                let functionModel = AbiFunctionModel(name: "doorsCount",
                                                     isConstant: true,
                                                     isPyable: false,
                                                     type: AbiFunctionType.function,
                                                     inputs: [],
                                                     outputs: [functionEntry])
                let decodedMessages = try decoder.getValueTypes(string: message, abiFunc: functionModel)
                let decodedMessage = decodedMessages.first!
                if let stringValue = decodedMessage.value as? String,
                    let intValue = Int(stringValue) {
                    let result = ResultHandler<Int, ContractError>(value: intValue)
                    completionBlock(result)
                } else {
                    let result = ResultHandler<Int, ContractError>(error: ContractError.cantGetValue)
                    completionBlock(result)
                }
            } catch let error {
                print("Doors count: \(error)")
                let result = ResultHandler<Int, ContractError>(error: ContractError.cantGetValue)
                completionBlock(result)
            }
        }
    }
    
    func getDoorInfoByIndex(login: String, index: Int,completionBlock: @escaping ContractCompletionHndler<Door>) {
        
        let input = AbiTypeValueInputModel(type: AbiParameterType.uint(size: 256), value: String(index))
        
        echo.queryContract(registrarNameOrId: login,
                           assetId: assetId,
                           contratId: contractId,
                           methodName: "getDoorInfoByIndex",
                           methodParams: [input]) { (result) in
            
            do {
                let message = try result.dematerialize()
                let door = try self.parceDoorInfo(message: message)
                let result = ResultHandler<Door, ContractError>(value: door)
                completionBlock(result)
            } catch let error {
                print("Doors by index: \(error)")
                let result = ResultHandler<Door, ContractError>(error: ContractError.cantGetValue)
                completionBlock(result)
            }
        }
    }
    
    func getDoorInfoByIdintifier(login: String, identifier: Int, completionBlock: @escaping ContractCompletionHndler<Door>) {
        
        let input = AbiTypeValueInputModel(type: AbiParameterType.int(size: 64), value: String(identifier))
        
        echo.queryContract(registrarNameOrId: login,
                           assetId: assetId,
                           contratId: contractId,
                           methodName: "getDoorInfoByIdentifier",
                           methodParams: [input]) { (result) in
                            
            do {
                let message = try result.dematerialize()
                let door = try self.parceDoorInfo(message: message)
                let result = ResultHandler<Door, ContractError>(value: door)
                completionBlock(result)
            } catch let error {
                print("Doors by identifier: \(error)")
                let result = ResultHandler<Door, ContractError>(error: ContractError.cantGetValue)
                completionBlock(result)
            }
        }
    }
    
    fileprivate func parceDoorInfo(message: String) throws -> Door {
        
        let decoder = AbiArgumentCoderImp()
        let functionEntryIndex = AbiFunctionEntries(name: "doorIndex", typeString: "uint256", type: .uint(size: 256))
        let functionEntryIdentifier = AbiFunctionEntries(name: "identifier",
                                                         typeString: "int64",
                                                         type: .int(size: 64))
        let functionEntryName = AbiFunctionEntries(name: "name",
                                                   typeString: "string",
                                                   type: .string)
        let functionModel = AbiFunctionModel(name: "getDoorInfoByIndex",
                                             isConstant: true,
                                             isPyable: false,
                                             type: AbiFunctionType.function,
                                             inputs: [functionEntryIndex],
                                             outputs: [functionEntryIdentifier, functionEntryName])
        
        let decodedMessages = try decoder.getValueTypes(string: message, abiFunc: functionModel)
        let decodedId = decodedMessages.first!
        let decodedName = decodedMessages[1]
        
        if let idStringValue = decodedId.value as? String,
            let idValue = Int(idStringValue),
            let name = decodedName.value as? String {
            
            let door = Door(identifier: idValue, name: name)
            return door
        } else {
            throw ContractError.cantGetValue
        }
    }
    
    func isOwner(login: String, completionBlock: @escaping ContractCompletionHndler<Bool>) {
        
        echo.queryContract(registrarNameOrId: login,
                           assetId: assetId,
                           contratId: contractId,
                           methodName: "isOwner",
                           methodParams: []) { (result) in
            
            do {
                let message = try result.dematerialize()
                
                let decoder = AbiArgumentCoderImp()
                let functionEntry = AbiFunctionEntries(name: "result", typeString: "bool", type: .bool)
                let functionModel = AbiFunctionModel(name: "isOwner",
                                                     isConstant: true,
                                                     isPyable: false,
                                                     type: AbiFunctionType.function,
                                                     inputs: [],
                                                     outputs: [functionEntry])
                let decodedMessages = try decoder.getValueTypes(string: message, abiFunc: functionModel)
                let decodedMessage = decodedMessages.first!
                if let stringValue = decodedMessage.value as? String,
                    let intValue = Int(stringValue) {
                    let result = ResultHandler<Bool, ContractError>(value: (intValue != 0))
                    completionBlock(result)
                } else {
                    let result = ResultHandler<Bool, ContractError>(error: ContractError.cantGetValue)
                    completionBlock(result)
                }
            } catch let error {
                print("Is owner: \(error)")
                let result = ResultHandler<Bool, ContractError>(error: ContractError.cantGetValue)
                completionBlock(result)
            }
        }
    }
    
    func openDoor(login: String, password: String, identifier: Int, completionBlock: @escaping ContractCompletionHndler<Bool>) {
        
        let input = AbiTypeValueInputModel(type: AbiParameterType.int(size: 64), value: String(identifier))
        
        echo.callContract(registrarNameOrId: login,
                          password: password,
                          assetId: assetId,
                          contratId: contractId,
                          methodName: "openDoor",
                          methodParams: [input]) { (result) in
            
            do {
                let message = try result.dematerialize()
                print("Open door: \(message)")
                let result = ResultHandler<Bool, ContractError>(value: message)
                completionBlock(result)
            } catch let error {
                print("Open door: \(error)")
                let result = ResultHandler<Bool, ContractError>(error: ContractError.cantGetValue)
                completionBlock(result)
            }
        }
    }
    
    func addDoor(login: String,
                 password: String,
                 identifier: Int,
                 name: String,
                 completionBlock: @escaping ContractCompletionHndler<Bool>) {
     
        let inputId = AbiTypeValueInputModel(type: AbiParameterType.int(size: 64), value: String(identifier))
        let inputName = AbiTypeValueInputModel(type: AbiParameterType.string, value: name)
        
        echo.callContract(registrarNameOrId: login,
                          password: password,
                          assetId: assetId,
                          contratId: contractId,
                          methodName: "addDoor",
                          methodParams: [inputId, inputName]) { (result) in
            
            do {
                let message = try result.dematerialize()
                print("Add door: \(message)")
                let result = ResultHandler<Bool, ContractError>(value: message)
                completionBlock(result)
            } catch let error {
                print("Add door: \(error)")
                let result = ResultHandler<Bool, ContractError>(error: ContractError.cantGetValue)
                completionBlock(result)
            }
        }
    }
    
    func removeDoor(login: String,
                    password: String,
                    identifier: Int,
                    completionBlock: @escaping ContractCompletionHndler<Bool>) {
        
        let inputId = AbiTypeValueInputModel(type: AbiParameterType.int(size: 64), value: String(identifier))
        
        echo.callContract(registrarNameOrId: login,
                          password: password,
                          assetId: assetId,
                          contratId: contractId,
                          methodName: "removeDoor",
                          methodParams: [inputId]) { (result) in
                            
            do {
                let message = try result.dematerialize()
                print("Remove door: \(message)")
                let result = ResultHandler<Bool, ContractError>(value: message)
                completionBlock(result)
            } catch let error {
                print("Remove door: \(error)")
                let result = ResultHandler<Bool, ContractError>(error: ContractError.cantGetValue)
                completionBlock(result)
            }
        }
    }
    
    func addUserToDoor(login: String,
                       password: String,
                       doorId: Int,
                       userId: String,
                       completionBlock: @escaping ContractCompletionHndler<Bool>) {
        
        guard let fixedUserId = userId.split(separator: ".").last else {
            return
        }
        
        let inputDoorId = AbiTypeValueInputModel(type: AbiParameterType.int(size: 64), value: String(doorId))
        let inputUserId = AbiTypeValueInputModel(type: AbiParameterType.address, value: String(fixedUserId))
        
        echo.callContract(registrarNameOrId: login,
                          password: password,
                          assetId: assetId,
                          contratId: contractId,
                          methodName: "addUserToDoor",
                          methodParams: [inputDoorId, inputUserId]) { (result) in
                            
            do {
                let message = try result.dematerialize()
                print("Add user to door: \(message)")
                let result = ResultHandler<Bool, ContractError>(value: message)
                completionBlock(result)
            } catch let error {
                print("Add user to door: \(error)")
                let result = ResultHandler<Bool, ContractError>(error: ContractError.cantGetValue)
                completionBlock(result)
            }
        }
    }
    
    func removeUserFromDoor(login: String,
                            password: String,
                            doorId: Int,
                            userId: String,
                            completionBlock: @escaping ContractCompletionHndler<Bool>) {
        
        guard let fixedUserId = userId.split(separator: ".").last else {
            return
        }
        
        let inputDoorId = AbiTypeValueInputModel(type: AbiParameterType.int(size: 64), value: String(doorId))
        let inputUserId = AbiTypeValueInputModel(type: AbiParameterType.address, value: String(fixedUserId))
        
        echo.callContract(registrarNameOrId: login,
                          password: password,
                          assetId: assetId,
                          contratId: contractId,
                          methodName: "removeUserFromDoor",
                          methodParams: [inputDoorId, inputUserId]) { (result) in
                            
            do {
                let message = try result.dematerialize()
                print("Remove user to door: \(message)")
                let result = ResultHandler<Bool, ContractError>(value: message)
                completionBlock(result)
            } catch let error {
                print("Remove user to door: \(error)")
                let result = ResultHandler<Bool, ContractError>(error: ContractError.cantGetValue)
                completionBlock(result)
            }
        }
    }
    
    func getDoorWhiteList(login: String,
                          doorId: Int,
                          completionBlock: @escaping ContractCompletionHndler<[String]>) {
        
        let inputDoorId = AbiTypeValueInputModel(type: AbiParameterType.int(size: 64), value: String(doorId))
        echo.queryContract(registrarNameOrId: login,
                           assetId: assetId,
                           contratId: contractId,
                           methodName: "getDoorWhiteList",
                           methodParams: [inputDoorId]) { (result) in
            
            do {
                let message = try result.dematerialize()
                print("Door white door: \(message)")
                
                var editedMessage = String(message[String.Index(encodedOffset: 128)...])
                
                var ids = [String]()
                while editedMessage.count>0 {
                    let decoder = AbiArgumentCoderImp()
                    let functionEntry = AbiFunctionEntries(name: "result",
                                                           typeString: "int64",
                                                           type: .int(size: 64))
                    let functionModel = AbiFunctionModel(name: "getDoorWhiteList",
                                                         isConstant: true,
                                                         isPyable: false,
                                                         type: AbiFunctionType.function,
                                                         inputs: [],
                                                         outputs: [functionEntry])
                    let decodedMessages = try decoder.getValueTypes(string: editedMessage, abiFunc: functionModel)
                    if let decodedMessage = decodedMessages.first,
                        let stringValue = decodedMessage.value as? String {
                        ids.append("1.2.\(stringValue)")
                    }
                    
                    editedMessage = String(editedMessage[String.Index(encodedOffset: 64)...])
                }
                
                let result = ResultHandler<[String], ContractError>(value: ids)
                completionBlock(result)
            } catch let error {
                print("Door white door: \(error)")
                let result = ResultHandler<[String], ContractError>(error: ContractError.cantGetValue)
                completionBlock(result)
            }
        }
    }
}
