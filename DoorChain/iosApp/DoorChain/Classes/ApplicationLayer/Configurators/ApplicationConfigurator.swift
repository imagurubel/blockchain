//
//  ApplicationConfigurator.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 13.09.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

class ApplicationConfigurator: ConfiguratorProtocol {
  
    func configure() {

        var rootView: UIViewController!

        let viewController = RootModuleConfigurator().configureModule().viewController
        rootView = viewController
        
        AppDelegate.currentWindow.rootViewController = rootView
    }
}
