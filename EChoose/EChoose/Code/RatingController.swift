//
//  RatingController.swift
//  EChoose
//
//  Created by Oparin Oleg on 28.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class RatingController: UIStackView {
    
    var starsRating = 0
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    override func draw(_ rect: CGRect) {
        let starButtons = self.subviews.filter{$0 is UIButton}
        var starTag = 1
        for button in starButtons {
            if let button = button as? UIButton{
                button.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
                button.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
                button.tag = starTag
                starTag = starTag + 1
            }
        }
       setStarsRating(rating:starsRating)
    }
    
    func setStarsRating(rating:Int){
        self.starsRating = rating
        let stackSubViews = self.subviews.filter{$0 is UIButton}
        for subView in stackSubViews {
            if let button = subView as? UIButton{
                if button.tag > starsRating {
                    button.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
                } else {
                    button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
                }
            }
        }
    }
    
    @objc func pressed(sender: UIButton) {
        generator.prepare()
        generator.impactOccurred()
        setStarsRating(rating: sender.tag)
    }
}
