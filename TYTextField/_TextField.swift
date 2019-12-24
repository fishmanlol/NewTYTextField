//
//  _TextField.swift
//  TYTextField
//
//  Created by Yi Tong on 12/23/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

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
            
    
            let path = pinCodeborderPath(in: rect)
            
            
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
    private func pinCodeborderPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        guard pinCodeCount > 0 else { return path }
        var lines: [(CGPoint, CGPoint)] = []

        let (start, end) = caculateStartEndPoint(in: rect)
        for (startPerSegement, endPerSegement) in slice(start: start, end: end) {
            let centerPerSegement = CGPoint.center(lhs: startPerSegement, rhs: endPerSegement)
            let diff = (lineLength - CGPoint.length(lhs: startPerSegement, rhs: endPerSegement)) / 2
            lines.append((startPerSegement.extended(diff), endPerSegement.extended(-diff)))
        }
        
        for (startPerLine, endPerLine) in lines {
            path.move(to: startPerLine)
            path.addLine(to: endPerLine)
        }
        
        return path
    }
    
    ///Slice line into segement according to pinCodeCount
    private func slice(start: CGPoint, end: CGPoint) -> [(CGPoint, CGPoint)] {
        var segements: [(CGPoint, CGPoint)] = []
        var startPerSegement = start
        let lengthPerSegement = (end - start) / pinCodeCount
        
        for _ in 0..<pinCodeCount {
            let endPerSegement = startPerSegement + lengthPerSegement
            segements.append((startPerSegement, endPerSegement))
            startPerSegement = endPerSegement
        }
        
        return segements
    }
    
    private func caculateStartEndPoint(in rect: CGRect) -> (CGPoint, CGPoint) {
        return (CGPoint(x: rect.minX, y: rect.maxY - _borderWidth), CGPoint(x: rect.maxX, y: rect.maxY - _borderWidth))
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
        var length: CGFloat {
            return sqrt((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y))
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
        
        mutating func extend(to length: CGFloat) {
            
        }
        
        enum Anchor {
            case start
            case end
            case center
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
            
            start = CGPoint(x: start.x + deltaX, y: start.y + deltaY)
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
            
            start = CGPoint(x: end.x + deltaX, y: end.y + deltaY)
        }
        
        private mutating func centerExtend(to length: CGFloat) {
            let halfLength = length / 2
            startExtend(to: halfLength)
            endExtend(to: halfLength)
        }
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func /(lhs: CGPoint, rhs: UInt) -> CGPoint {
        return CGPoint(x: lhs.x / CGFloat(rhs), y: lhs.y / CGFloat(rhs))
    }

    static func center(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: (lhs.x + rhs.x) * 0.5, y: (lhs.y + rhs.y) * 0.5)
    }

    static func length(lhs: CGPoint, rhs: CGPoint) -> CGFloat {
        return sqrt((rhs.x - lhs.x) * (rhs.x - lhs.x) + (rhs.y - lhs.y) * (rhs.y - lhs.y))
    }

    func extended(_ length: CGFloat) -> CGPoint {
        if x == 0 {
            return CGPoint(x: x, y: y + length)
        } else {
            let k = y / x
            let x1 = sqrt(length * length / (k*k + 1))
            let y1 = x1 * k
            if length > 0 {
                return self + CGPoint(x: x1, y: y1)
            } else {
                return self - CGPoint(x: x1, y: y1)
            }
        }
    }
}
