//
//  _TextField.swift
//  TYTextField
//
//  Created by Yi Tong on 12/23/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//
import CoreGraphics

class _TextField: UITextField {
    
    //MARK: - pin code
    internal var isPinCode: Bool
    internal var pinCodeCount: UInt
    internal var lineLength: CGFloat = 20
    
    //MARK: - style
    internal var _borderStyle: TYNormalTextField.BorderStyle = .singleLine {
        didSet {
            setNeedsDisplay()
        }
    }
    
    internal var _borderColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    internal var _borderWidth: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //MARK: - initialization
    init(frame: CGRect, isPinCode: Bool, pinCodeCount: UInt = 0) {
        self.isPinCode = isPinCode
        self.pinCodeCount = pinCodeCount
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        if isPinCode {//draw pin code style
            //set kern
            let kern = caculateKern(in: rect, count: pinCodeCount)
            setDefaultTextAttribute(key: .kern, value: kern)
            
            let path = pinCodeborderPath(in: rect)
            _borderColor.setStroke()
            path.stroke()
            
            return
        }
        
        if _borderStyle == .singleLine { //Single line style
            let (start, end) = caculateStartEndPoint(in: rect)
            let path = UIBezierPath()

            path.move(to: start)
            path.addLine(to: end)
            path.lineWidth = _borderWidth
            _borderColor.setStroke()
            path.stroke()
            
            return
        }
    }
    
    //MARK: - Helpers
    private func caculateKern(in rect: CGRect, count: UInt) -> CGFloat {
        return 20
    }
    
    private func pinCodeborderPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        guard pinCodeCount > 0 else { return path }

        let (start, end) = caculateStartEndPoint(in: rect)
        let bottomLine = Line(start: start, end: end)
        for var segement in bottomLine.slice(count: pinCodeCount) {
            segement.extend(to: lineLength, anchor: .start)
            path.move(to: segement.start)
            path.addLine(to: segement.end)
        }
        
        return path
    }
    
    private func caculateStartEndPoint(in rect: CGRect) -> (CGPoint, CGPoint) {
        return (CGPoint(x: rect.minX, y: rect.maxY - _borderWidth), CGPoint(x: rect.maxX, y: rect.maxY - _borderWidth))
    }
    
    private func setDefaultTextAttribute(key: NSAttributedString.Key, value: Any) {
        defaultTextAttributes[key] = value
    }
    
    //MARK: - Line struct
    struct Line: CustomStringConvertible {
        var description: String {
            get {
                "(\(start.x), \(start.y)) -> (\(end.x), \(end.y))"
            }
        }
        
        var start: CGPoint
        var end: CGPoint
        var k: CGFloat? {
            if end.x == start.x {
                return nil
            } else {
                return (end.y - start.y) / (end.x - start.x)
            }
        }
        var length: CGFloat {
            return sqrt((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y))
        }
        
        func slice(count: UInt) -> [Line] {
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
        
        mutating func extend(_ length: CGFloat, anchor: Anchor) {
            switch anchor {
            case .start:
                endExtend(length)
            case .end:
                startExtend(length)
            case .center:
                centerExtend(length)
            }
        }
        
        mutating func extend(to length: CGFloat, anchor: Anchor) {
            switch anchor {
            case .start:
                endExtend(to: length)
            case .end:
                startExtend(to: length)
            case .center:
                centerExtend(to: length)
            }
        }
        
        private mutating func endExtend(_ length: CGFloat) {
            guard let k = k else {
                end = CGPoint(x: end.x, y: end.y + length)
                return
            }
            
            let f: CGFloat = length > 0 ? 1 : -1
            let deltaX = sqrt(length * length / (k*k + 1)) * f
            let deltaY = deltaX * k * f
            
            end = CGPoint(x: end.x + deltaX, y: end.y + deltaY)
        }
        
        private mutating func startExtend(_ length: CGFloat) {
            guard let k = k else {
                start = CGPoint(x: start.x, y: start.y + length)
                return
            }
            
            let f: CGFloat = length > 0 ? 1 : -1
            let deltaX = sqrt(length * length / (k*k + 1)) * f
            let deltaY = deltaX * k * f
            
            start = CGPoint(x: start.x - deltaX, y: start.y - deltaY)
        }
        
        private mutating func centerExtend(_ length: CGFloat) {
            let halfLength = length / 2
            startExtend(halfLength)
            endExtend(halfLength)
        }
        
        private mutating func endExtend(to length: CGFloat) {
            guard let k = k else {
                end = CGPoint(x: end.x, y: end.y > 0 ? length : -length)
                return
            }
            
            let f: CGFloat = length > 0 ? 1 : -1
            let deltaX = sqrt(length * length / (k*k + 1)) * f
            let deltaY = deltaX * k * f
            
            end = CGPoint(x: start.x + deltaX, y: start.y + deltaY)
        }
        
        private mutating func startExtend(to length: CGFloat) {
            guard let k = k else {
                start = CGPoint(x: start.x, y: start.y > 0 ? length : -length)
                return
            }
            
            let f: CGFloat = length > 0 ? 1 : -1
            let deltaX = sqrt(length * length / (k*k + 1)) * f
            let deltaY = deltaX * k * f
            
            start = CGPoint(x: end.x - deltaX, y: end.y - deltaY)
        }
        
        private mutating func centerExtend(to length: CGFloat) {
            let shrink = (self.length - length) / 2
            startExtend(-shrink)
            endExtend(-shrink)
        }
        
        //MARK: - Anchor
        ///The anchor will hold when line extend
        enum Anchor {
            case start
            case end
            case center
        }
    }
}

//MARK: - CGPoint extension
extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
