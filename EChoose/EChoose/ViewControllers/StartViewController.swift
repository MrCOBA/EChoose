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
    let globalManager = GlobalManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalManager.loadData()
        loadIndicator.startAnimating()
        startAnimation()
        subscribe(forNotification: Notification.Name("loginSuccess"))
        subscribe(forNotification: Notification.Name("loginUnsuccess"))
        globalManager.tokenInit()
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
    }
    
    func subscribe(forNotification name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_:)), name: name, object: nil)
    }
    
    func unsubscribe(fromNotification name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mainScreenSegue" {
            let destination = segue.destination as! UITabBarController
            
            destination.selectedIndex = 2
            destination.navigationController?.setNavigationBarHidden(true, animated: true)
            
        } else if segue.identifier == "loginScreenSegue" {
            
            
        }
    }
    
    @objc func notificationHandler(_ notification: Notification) {
        if notification.name.rawValue == "loginSuccess" {
            
            DispatchQueue.main.async {[unowned self] in
                unsubscribe(fromNotification: Notification.Name("loginSuccess"))
                unsubscribe(fromNotification: Notification.Name("loginUnsuccess"))
                loadIndicator.isHidden = true
                loadIndicator.stopAnimating()
                logoImageView.stopAnimating()
                globalManager.initRefresh()
                performSegue(withIdentifier: "mainScreenSegue", sender: nil)
            }
        } else if notification.name.rawValue == "loginUnsuccess" {
            
            DispatchQueue.main.async {[unowned self] in
                unsubscribe(fromNotification: Notification.Name("loginSuccess"))
                unsubscribe(fromNotification: Notification.Name("loginUnsuccess"))
                loadIndicator.isHidden = true
                loadIndicator.stopAnimating()
                logoImageView.stopAnimating()
                performSegue(withIdentifier: "loginScreenSegue", sender: nil)
            }
        }
    }
}
