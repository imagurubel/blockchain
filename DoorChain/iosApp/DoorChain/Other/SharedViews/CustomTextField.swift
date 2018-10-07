//
//  CustomTextField.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 05.10.2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

@objc protocol CustomTextFieldDelegate: class {
    
    func textDidChange(textField: CustomTextField, resultText: String?)
    @objc optional func textFieldDidBeginEditing(textField: CustomTextField)
    @objc optional func returnDidTap(textField: CustomTextField)
    @objc optional func textWillChange(textFiled: CustomTextField, resultText: String?) -> Bool
}

class CustomTextField: UIView, ErrorableView {

    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: CustomTextFieldDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configCornerRadius()
        configTextField()
        bindToTextField()
        configGesture()
        unhighlightView()
    }
    
    // MARK: Configuration
    
    fileprivate func configCornerRadius() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }
    
    fileprivate func configTextField() {
        textField.tintColor = R.clr.doorChain.yellowMain()
        textField.delegate = self
    }
    
    fileprivate func bindToTextField() {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
    }
    
    fileprivate func configGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CustomTextField.actionTap(_:)))
        addGestureRecognizer(gesture)
    }
    
    @objc func actionTap(_ sender: Any) {
        textField.becomeFirstResponder()
    }
    
    // MARK: Public
    
    func setDisableState() {
        
        textField.isUserInteractionEnabled = false
        backgroundColor = R.clr.doorChain.grayNotEvailable()
        layer.borderColor = R.clr.doorChain.grayBorderCkeckBox().cgColor
    }
    
    func startEditing() {
        textField.becomeFirstResponder()
    }
    
    func setPlacehodlerText (_ placeholder: String) {
        textField.placeholder = placeholder
    }
    
    func setText (_ text: String?) {
        
        if let text = text {
            textField.text = text
            highlightView()
        } else {
            textField.text = ""
            unhighlightView()
        }
    }
    
    func setKeyboardType(_ type: UIKeyboardType) {
        
        textField.keyboardType = type
        
        if type == .decimalPad || type == .numberPad || type == .phonePad {
            configDoneButton()
        }
    }
    
    fileprivate func configDoneButton() {
        
        let toolBar = UIToolbar()
        toolBar.backgroundColor = R.clr.doorChain.graySelected()
        toolBar.clipsToBounds = true
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                          NSAttributedStringKey.font: R.font.geometria(size: 17)!]
        done.setTitleTextAttributes(attributes, for: .normal)
        
        toolBar.items = [flexSpace, done]
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
    }
    
    @objc fileprivate func doneButtonAction() {
        
        textField.resignFirstResponder()
        delegate?.returnDidTap?(textField: self)
    }
    
    func getText () -> String? {
        
        return textField.text
    }
    
    func highlightView() {
        if textField.isFirstResponder {
            layer.borderWidth = 1
//            layer.borderColor = R.clr.DoorChainColors.blueTabs().cgColor
        }
    }
    
    func unhighlightView() {
        if !textField.isFirstResponder {
            layer.borderWidth = 1
            layer.borderColor = R.clr.doorChain.grayBorders().cgColor
        }
    }
}

extension CustomTextField: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing?(textField: self)
        highlightView()
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        unhighlightView()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.keyboardType != .decimalPad && textField.keyboardType != .numberPad {
            return true
        }
        
        guard let text = textField.text else {
            return true
        }
        
        var isValid = true
        if (string == "," || string == ".") {
            isValid = !text.contains(string) && !text.isEmpty
        }
        
        let resultText = (text as NSString).replacingCharacters(in: range, with: string)
        if let willChange = delegate?.textWillChange?(textFiled: self, resultText: resultText) {
            isValid = willChange
        }
        
        return isValid
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (delegate?.returnDidTap?(textField: self)) == nil {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.textDidChange(textField: self, resultText: textField.text)
    }
}
