//
//  TYTextFieldTests.swift
//  TYTextFieldTests
//
//  Created by Yi Tong on 12/23/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import XCTest
@testable import TYTextField

class TYTextFieldTests: XCTestCase {
    var lines: [_TextField.Line] = []
    let error: CGFloat = 0.00001
    
    override func setUp() {
        lines.append(_TextField.Line(start: CGPoint(x: 1, y: 1), end: CGPoint(x: 3, y: 3)))
        lines.append(_TextField.Line(start: CGPoint(x: 0, y: 1), end: CGPoint(x: 0, y: 3)))
        lines.append(_TextField.Line(start: CGPoint(x: 1, y: 0), end: CGPoint(x: 3, y: 0)))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLineExtendStart() {
        let length: CGFloat = 10
        
        for var line in lines {
            let originalLength = line.length
            line.extend(length, anchor: .start)
            let extendedLength = line.length
            assert(originalLength - extendedLength - length < error)
        }
    }
    
    func testLineExtendEnd() {
        let length: CGFloat = 10
        
        for var line in lines {
            let originalLength = line.length
            line.extend(length, anchor: .end)
            let extendedLength = line.length
            assert(originalLength - extendedLength - length < error)
        }
    }
    
    func testLineExtendCenter() {
        let length: CGFloat = 10
        
        for var line in lines {
            let originalLength = line.length
            line.extend(length, anchor: .center)
            let extendedLength = line.length
            assert(originalLength - extendedLength - length < error)
        }
    }
    
    func testLineSlice() {
        for line in lines {
            let slicedLines = line.slice(count: 3)
            assert(slicedLines.dropFirst().allSatisfy { $0.k == slicedLines[0].k && $0.length == slicedLines[0].length })
        }
    }
}
