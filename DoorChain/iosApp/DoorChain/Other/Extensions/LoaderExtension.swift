//
//  LoaderExtension.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 06/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIViewController {
    
    func showLoader() {
        
        let loaderView = UIView()
        loaderView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        loaderView.tag = 666
        
        view.addSubview(loaderView)
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.startAnimating()
        loaderView.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        loaderView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func hideLoader() {
        
        guard let loaderView = view.viewWithTag(666) else {
            return
        }
        
        loaderView.removeFromSuperview()
    }
}
