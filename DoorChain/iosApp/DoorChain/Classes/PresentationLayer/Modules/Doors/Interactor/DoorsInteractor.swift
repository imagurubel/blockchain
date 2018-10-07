//
//  DoorsDoorsInteractor.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 06/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

class DoorsInteractor {

    weak var output: DoorsInteractorOutput!
    var userFacade: AuthFacadeService!
    var contracts: ContractService!
    
    var doors = [Door]()
    var isOwner = false
}

// MARK: - DoorsInteractorInput

extension DoorsInteractor: DoorsInteractorInput {
    
    func getData() -> ([Door], Bool) {
        return (doors, isOwner)
    }
 
    func loadData() {
        
        guard let login = userFacade.getLogin() else {
            return
        }
        
        var ownerLoaded = false
        var doorsLoaded = false
        
        doors.removeAll()
        
        output.loadingStarted()
        
        contracts.getDoorsCount(login: login) { (result) in
            
            do {
                let doorsCount = try result.dematerialize()
                var wasError = false
                var loadedDoors = 0
                for index in 0..<doorsCount {
                    self.contracts.getDoorInfoByIndex(login: login, index: index, completionBlock: { (result) in
                        
                        do {
                            let door = try result.dematerialize()
                            self.doors.append(door)
                            loadedDoors += 1
                            if loadedDoors == doorsCount {
                                doorsLoaded = true
                                if wasError {
                                    self.doors.removeAll()
                                }
                                
                                if doorsLoaded && ownerLoaded {
                                    self.output.loadingEnded()
                                    self.output.dataLoaded()
                                }
                            }
                        } catch {
                            wasError = true
                            self.output.loadingEnded()
                            print("Load door error: \(error)")
                        }
                    })
                }
            } catch let error {
                self.output.loadingEnded()
                print("Load count error: \(error)")
            }
        }
        
        contracts.isOwner(login: login) { (result) in
            
            do {
                self.isOwner = try result.dematerialize()
                ownerLoaded = true
                
                if doorsLoaded && ownerLoaded {
                    self.output.dataLoaded()
                    self.output.loadingEnded()
                }
            } catch let error {
                self.output.loadingEnded()
                print("Load owner error: \(error)")
            }
        }
    }
    
    func openDoor(door: Door) {
        
        guard let login = userFacade.getLogin(),
            let password = userFacade.getPassword(),
            let identifier = userFacade.getIdentifier() else {
                return
        }
        
        output.loadingStarted()
        
        contracts.getDoorWhiteList(login: login, doorId: door.identifier) { (result) in
            
            do {
                let ids = try result.dematerialize()
                if ids.contains(identifier) || self.isOwner {
                    self.contracts.openDoor(login: login, password: password, identifier: door.identifier) { (result) in
                        
                        do {
                            _ = try result.dematerialize()
                            self.output.showError(message: "Door will open")
                        } catch {
                            self.output.showError(message: "Error in opening the door")
                        }
                    }
                } else {
                    self.output.showError(message: "You are not allowed to open this door")
                }
            } catch {
                self.output.showError(message: "Error in opening the door")
            }
        }
    }
}
