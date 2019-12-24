//
//  TYTextField.swift
//  TYTextField
//
//  Created by Yi Tong on 12/23/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//
import SnapKit

public class TYNormalTextField: UIView {
    internal weak var _textField: _TextField!
    
    public lazy var label: UILabel = {
        return createLabel()
    }()
    
    public var leftView: UIView? {
        didSet {
            didChangeLeftView()
        }
    }
    
    public var rightView: UIView? {
        didSet {
            didChangeRightView()
        }
    }
    
    ///No effect for TYPinCodeTextField
    public var borderStyle: BorderStyle = .singleLine {
        didSet {
            _textField._borderStyle = borderStyle
        }
    }
    
    public var borderColor: UIColor = .black {
        didSet {
            _textField._borderColor = borderColor
        }
    }
    
    public var borderWidth: CGFloat = 1 {
        didSet {
            _textField._borderWidth = borderWidth
        }
    }
    
    private func caculateStartEndPoint(in rect: CGRect) -> (CGPoint, CGPoint) {
        return (CGPoint(x: rect.minX, y: rect.maxY - borderWidth), CGPoint(x: rect.maxX, y: rect.maxY - borderWidth))
    }
    
    //MARK: - Initializations
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp(frame: frame)
    }
    
    public init(labelText: String, frame: CGRect) {
        super.init(frame: frame)
        setUp(frame: frame)
        
        label.text = labelText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Helpers
    private func setUp(frame: CGRect) {
        self._textField = createTextField(frame: frame)
        _textField.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        addSubview(_textField)
        _textField.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func didChangeLeftView() {
        if leftView == nil {
            _textField.leftView = nil
            _textField.leftViewMode = .never
        } else {
            _textField.leftView = leftView
            _textField.leftViewMode = .always
        }
    }
    
    private func didChangeRightView() {
        if rightView == nil {
            _textField.rightView = nil
            _textField.rightViewMode = .never
        } else {
            _textField.rightView = rightView
            _textField.rightViewMode = .always
        }
    }
    
    ///Subclass override this function for TYPinCodeText to provide customize textField
    func createTextField(frame: CGRect) -> _TextField {
        let tf = _TextField(frame: frame, isPinCode: false)
        tf.placeholder = "placeholder"
        return tf
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        self.label = label
        addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        
        return label
    }
    
    public enum BorderStyle {
        case rounded
        case singleLine
        case none
    }
}

extension UIView {
    func pinToInside(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subview]|", metrics: nil, views: ["subview": subview]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|", metrics: nil, views: ["subview": subview]))
    }
}
