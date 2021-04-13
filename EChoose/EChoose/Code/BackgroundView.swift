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
          
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
            shadowLayer.fillColor = UIColor(named: "MainColor")?.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = .zero
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 10

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
