//
//  ViewController.swift
//  TYTextFieldDemo
//
//  Created by Yi Tong on 12/23/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import TYTextField

class ViewController: UIViewController {
    weak var tf: TYNormalTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 100, y: 100, width: 200, height: 60)
        let tf = TYPinCodeTextField(labelText: "Pin Code", frame: frame)
        self.tf = tf
        view.addSubview(tf)

    }
}
