//
//  CustomTextFieldWithImage.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05.10.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

class CustomTextFieldWithImage: CustomTextField {

    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(_ image: UIImage!) {
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        unhighlightView()
    }
    
    override func highlightView() {
        super.highlightView()
        
        imageView.tintColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func unhighlightView() {
        super.unhighlightView()
        
        if textField.text == nil || textField.text!.count == 0 {
            imageView.tintColor = UIColor.black.withAlphaComponent(0.25)
        }
    }
}
