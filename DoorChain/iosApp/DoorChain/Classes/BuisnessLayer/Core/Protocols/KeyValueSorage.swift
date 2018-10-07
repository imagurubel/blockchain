//
//  KeyValueSorage.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 13.09.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Foundation

protocol KeyValueStoring {
    
    func getData(key: String) -> Data?
    func set(key: String, value: Data)
    func get(key: String) -> String?
    func set(key: String, value: String)
    func remove(key: String)
}
