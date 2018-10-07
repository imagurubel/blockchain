//
//  BusinessLayerAssembly.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 13.09.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Swinject
import Moya

class BusinessLayerAssembly {
    
    init(parent: Assembler) {
        let assemblies: [Assembly] = [ServicesAssembly(), CoreComponentAssembly(), ProxyAssembly()]
        parent.apply(assemblies: assemblies)
    }
}
