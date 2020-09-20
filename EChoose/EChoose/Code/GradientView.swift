//
//  GradientView.swift
//  EChoose
//
//  Created by Oparin Oleg on 29.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class GradientView: UIView {

    let gradient = CAGradientLayer()
    let colorsOrder = [
        [#colorLiteral(red: 0, green: 0.4156862745, blue: 0.2078431373, alpha: 1).cgColor, #colorLiteral(red: 0.960748136, green: 0.9848688245, blue: 0.4547813535, alpha: 1).cgColor, #colorLiteral(red: 0.3808822285, green: 0.7240369789, blue: 1, alpha: 1).cgColor],
        [#colorLiteral(red: 0.3808822285, green: 0.7240369789, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0.4156862745, blue: 0.2078431373, alpha: 1).cgColor, #colorLiteral(red: 0.960748136, green: 0.9848688245, blue: 0.4547813535, alpha: 1).cgColor],
        [#colorLiteral(red: 0.960748136, green: 0.9848688245, blue: 0.4547813535, alpha: 1).cgColor, #colorLiteral(red: 0.3808822285, green: 0.7240369789, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0.4156862745, blue: 0.2078431373, alpha: 1).cgColor],
    ]
    
    override func draw(_ rect: CGRect) {
        
        
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        gradient.colors = [#colorLiteral(red: 0, green: 0.4156862745, blue: 0.2078431373, alpha: 1).cgColor, #colorLiteral(red: 0.960748136, green: 0.9848688245, blue: 0.4547813535, alpha: 1).cgColor, #colorLiteral(red: 0.3808822285, green: 0.7240369789, blue: 1, alpha: 1).cgColor]
        layer.insertSublayer(gradient, at: 0)
    }
    
    override func didMoveToWindow() {
        
        let gradientChangeAnimationFirstIter = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimationFirstIter.duration = 2
        gradientChangeAnimationFirstIter.fromValue = colorsOrder[0]
        gradientChangeAnimationFirstIter.toValue = colorsOrder[1]
        gradientChangeAnimationFirstIter.fillMode = CAMediaTimingFillMode.forwards
        
        let gradientChangeAnimationSecondIter = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimationSecondIter.duration = 2
        gradientChangeAnimationSecondIter.beginTime = 2
        gradientChangeAnimationSecondIter.fromValue = colorsOrder[1]
        gradientChangeAnimationSecondIter.toValue = colorsOrder[2]
        gradientChangeAnimationSecondIter.fillMode = CAMediaTimingFillMode.forwards
        
        let gradientChangeAnimationThirdIter = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimationThirdIter.duration = 2
        gradientChangeAnimationThirdIter.beginTime = 4
        gradientChangeAnimationThirdIter.fromValue = colorsOrder[2]
        gradientChangeAnimationThirdIter.toValue = colorsOrder[0]
        gradientChangeAnimationThirdIter.fillMode = CAMediaTimingFillMode.forwards
        
        let group = CAAnimationGroup()
        group.duration = 6
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        group.repeatCount = .infinity
        group.animations = [gradientChangeAnimationFirstIter, gradientChangeAnimationSecondIter, gradientChangeAnimationThirdIter]
        
        gradient.add(group, forKey: "colorChange")
    }
}
