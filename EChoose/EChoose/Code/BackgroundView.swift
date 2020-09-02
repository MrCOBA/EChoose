//
//  BackgroundView.swift
//  EChoose
//
//  Created by Oparin Oleg on 29.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class BackgroundView: UIView {

    private var shadowLayer: CAShapeLayer!
        
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.backgroundColor = .none
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
          
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
            shadowLayer.fillColor = #colorLiteral(red: 0.6349999905, green: 0.8550000191, blue: 0.5920000076, alpha: 1)
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = .zero
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 10

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
