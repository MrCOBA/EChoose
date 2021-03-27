//
//  CustomSearchBar.swift
//  EChoose
//
//  Created by Oparin Oleg on 15.02.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSearchBar: UISearchBar {

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
    
    @IBInspectable var textColor: UIColor = .black {
        didSet {
            let textFieldInsideSearchBar = value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = textColor
        }
    }
    
    @IBInspectable var placeholderTintColor: UIColor = .black {
        didSet {
            
            let textFieldInsideSearchBar = value(forKey: "searchField") as? UITextField
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: placeholder!)
            attributeString.addAttribute(.foregroundColor, value: placeholderTintColor, range: NSMakeRange(0, placeholder!.count))
            textFieldInsideSearchBar!.attributedPlaceholder = attributeString
        }
    }
    
    @IBInspectable var textFieldBackgroundColor: UIColor = .black {
        
        didSet {
            
            let textFieldInsideSearchBar = value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.backgroundColor = textFieldBackgroundColor
        }
    }
}
