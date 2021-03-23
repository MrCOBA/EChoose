//
//  CustomMapView.swift
//  EChoose
//
//  Created by Oparin Oleg on 15.02.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable
class CustomMapView: MKMapView {

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
