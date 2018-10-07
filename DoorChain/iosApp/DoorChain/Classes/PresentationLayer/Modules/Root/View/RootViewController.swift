//
//  RootRootViewController.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 19/03/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var output: RootViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        output.viewPresented()
    }
}

// MARK: - RootViewInput

extension RootViewController: RootViewInput {
  
	func setupInitialState() {
    
  	}
  
}
