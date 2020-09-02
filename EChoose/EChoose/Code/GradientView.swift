//
//  GradientView.swift
//  EChoose
//
//  Created by Oparin Oleg on 29.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override func draw(_ rect: CGRect) {
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        let firstColor = #colorLiteral(red: 0, green: 0.4156862745, blue: 0.2078431373, alpha: 1)
        let secondColor = #colorLiteral(red: 0.960748136, green: 0.9848688245, blue: 0.4547813535, alpha: 1)
        let thirdColor = #colorLiteral(red: 0.3808822285, green: 0.7240369789, blue: 1, alpha: 1)
        gradient.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor].shuffled()
        layer.insertSublayer(gradient, at: 0)
    }
}
