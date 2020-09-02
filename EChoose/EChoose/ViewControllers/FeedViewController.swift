//
//  FeedViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 25.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardInformationView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var likedislikeImageView: UIImageView!
    @IBOutlet weak var blurView: UIView!
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    var divisor: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        divisor = (view.frame.width / 2) / 0.61
        setUI()
    }
    //MARK: - Setting up UI
    func setUI(){
        
        self.overrideUserInterfaceStyle = .light
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowColor = UIColor.black.cgColor
    }

    @IBAction func prifileButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    
    @IBAction func cardPan(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y)
        
        let scale = min(100/abs(xFromCenter), 1)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor).scaledBy(x: scale, y: scale)
        
        if xFromCenter > 0 {
            likedislikeImageView.image = UIImage(named: "likeImage")
            likedislikeImageView.tintColor = #colorLiteral(red: 0.5009238996, green: 1, blue: 0.4745031706, alpha: 1)
        } else {
            likedislikeImageView.image = UIImage(named: "dislikeImage")
            likedislikeImageView.tintColor = #colorLiteral(red: 1, green: 0.400758059, blue: 0.3482903581, alpha: 1)
        }
        likedislikeImageView.alpha = abs(xFromCenter) / view.center.x
        blurView.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == .ended {
            
            if card.center.x < 75 {
                UIView.animate(withDuration: 1, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 85)
                    card.alpha = 0
                })
                generator.prepare()
                generator.impactOccurred()
            }
            else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 1, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 85)
                    card.alpha = 0
                })
                generator.prepare()
                generator.impactOccurred()
            }
            
            resetCard()
        }
    }
    
    func resetCard() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.cardView.center = self.view.center
            self.cardView.alpha = 1
            self.cardView.transform = .identity
            self.likedislikeImageView.alpha = 0
            self.blurView.alpha = 0
        })
    }
}
