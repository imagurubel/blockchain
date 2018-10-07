//
//  StorageCore.swift
//  DoorChain
//
//  Created by Евгения Григорович on 10/5/18.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Foundation

protocol StorageCore {
    
    var storage: KeyValueStoring {get set}
    func get<T>(key: String, type: T.Type) -> T? where T: Decodable
    func get(key: String) -> String?
    func set<T: Codable>(key: String, value: T)
    func remove(key: String)
}

extension StorageCore {
    
    func get<T>(key: String, type: T.Type) -> T? where T: Decodable {
        
        if let data = storage.getData(key: key) {
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                return nil
            }
        }
        
        return nil
    }
    
    func get(key: String) -> String? {
        
        if let string = storage.get(key: key) {
            return string
        }
        return nil
    }
    
    func set<T: Codable>(key: String, value: T) {
        
        if let string = value as? String {
            storage.set(key: key, value: string)
        } else if let data = try? JSONEncoder().encode(value) {
            storage.set(key: key, value: data)
        }
    }
    
    func remove(key: String) {
        storage.remove(key: key)
    }
}
