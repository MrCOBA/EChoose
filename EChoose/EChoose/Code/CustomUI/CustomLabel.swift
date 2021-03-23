//
//  CustomLabel.swift
//  EChoose
//
//  Created by Oparin Oleg on 17.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

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

}
