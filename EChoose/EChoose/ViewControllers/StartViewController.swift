//
//  StartViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 06.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadIndicator.startAnimating()
        startAnimation()
    }

    func setUI() {
        
        logoImageView.layer.cornerRadius = 5
    }
    
    func startAnimation() {
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotateAnimation.duration = 4
        
        let roundingAnimationFront = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
        roundingAnimationFront.fromValue = 5
        roundingAnimationFront.toValue = logoImageView.frame.width / 2
        roundingAnimationFront.duration = 2
        
        let roundingAnimationBack = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
        roundingAnimationBack.fromValue = logoImageView.frame.width / 2
        roundingAnimationBack.toValue = 5
        roundingAnimationBack.duration = 2
        roundingAnimationBack.beginTime = 2
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [rotateAnimation, roundingAnimationFront, roundingAnimationBack]
        animationGroup.repeatCount = .infinity
        animationGroup.duration = 4
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        logoImageView.layer.add(animationGroup, forKey: "groupAnimation")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.autoreverses = true
        opacityAnimation.duration = 1
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacityAnimation.repeatCount = .infinity
        
        infoLabel.layer.add(opacityAnimation, forKey: #keyPath(CALayer.opacity))
        
        login()
    }
    
    func login() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            sleep(12)
            
            DispatchQueue.main.async {
                
                self.logoImageView.stopAnimating()
                self.loadIndicator.stopAnimating()
                self.performSegue(withIdentifier: "startSegue", sender: nil)
            }
        }
    }
}
