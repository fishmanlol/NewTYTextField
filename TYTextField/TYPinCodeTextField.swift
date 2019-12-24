//
//  TYPinCodeTextField.swift
//  TYTextField
//
//  Created by Yi Tong on 12/23/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

public class TYPinCodeTextField: TYNormalTextField {
    override func createTextField(frame: CGRect) -> _TextField {
        let tf = _TextField(frame: frame, isPinCode: true, pinCodeCount: 6)
        return tf
    }
    
    
}
