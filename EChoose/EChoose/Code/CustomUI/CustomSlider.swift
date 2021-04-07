//
//  CustomSlider.swift
//  EChoose
//
//  Created by Oparin Oleg on 07.04.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {

    
    override var isEnabled: Bool {
        
        didSet {
            
            if isEnabled {
                
                minimumTrackTintColor = UIColor(named: "FirstColorGradient")
                maximumTrackTintColor = UIColor(named: "dislikeColor")
            } else {
                
                minimumTrackTintColor = .lightGray
                maximumTrackTintColor = .lightGray
            }
        }
    }

}
