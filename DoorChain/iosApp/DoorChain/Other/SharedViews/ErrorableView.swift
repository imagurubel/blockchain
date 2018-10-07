//
//  TextFieldErrorable.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05.10.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorableView {
    
    func showErrorState()
    func hideErrorState()
}

extension ErrorableView where Self: UIView {
    
    func showErrorState() {
        layer.borderWidth = 1
        layer.borderColor = R.clr.doorChain.redMain().cgColor
    }
    
    func hideErrorState() {
        layer.borderWidth = 0
    }
}
