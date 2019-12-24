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
        let tf = TYPasswordTextField(labelText: "Password", frame: frame)
        self.tf = tf
        view.addSubview(tf)
        
        let line = Line(start: CGPoint(x: 1, y: 1), end: CGPoint(x: 4, y: 4))
        print(line.slice(count: 3))
    }
}

struct Line {
    var start: CGPoint
    var end: CGPoint
    var k: CGFloat? {
        if end.x == start.x {
            return nil
        } else {
            return (end.y - start.y) / (end.x - start.x)
        }
    }
    
    func slice(count: Int) -> [Line] {
        var lines: [Line] = []
        
        let deltaX = (end.x - start.x) / CGFloat(count)
        let deltaY = (end.y - start.y) / CGFloat(count)
        var tempStart = start
        for _ in 0..<count {
            let tempEnd = CGPoint(x: tempStart.x + deltaX, y: tempStart.y + deltaY)
            lines.append(Line(start: tempStart, end: tempEnd))
            tempStart = tempEnd
        }
        
        return lines
    }
    
    //        func rightExtended(_ length: CGFloat) -> CGPoint {
    //            if x == 0 {
    //                return CGPoint(x: x, y: y + length)
    //            } else {
    //                let k = y / x
    //                let x1 = sqrt(length * length / (k*k + 1))
    //                let y1 = x1 * k
    //                if length > 0 {
    //                    return self + CGPoint(x: x1, y: y1)
    //                } else {
    //                    return self - CGPoint(x: x1, y: y1)
    //                }
    //            }
    //        }
    
    
}
