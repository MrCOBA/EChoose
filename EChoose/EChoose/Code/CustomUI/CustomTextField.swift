//
//  CustomTextField.swift
//  EChoose
//
//  Created by Oparin Oleg on 15.02.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var placeholderTintColor: UIColor = .black {
        didSet {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: placeholder!)
            attributeString.addAttribute(.foregroundColor, value: placeholderTintColor, range: NSMakeRange(0, placeholder!.count))
            attributedPlaceholder = attributeString
        }
    }
}
