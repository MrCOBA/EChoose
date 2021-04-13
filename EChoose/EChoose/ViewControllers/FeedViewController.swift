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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likedislikeImageView: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var noOffersView: CustomView!
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    var divisor: CGFloat!
    var globalManager: GlobalManager = GlobalManager.shared
    var servicesManager: ServicesManager = ServicesManager.shared
    var offersManager: OffersManager = OffersManager.shared
    
    var offer: Offer?
    var user: UserDefault?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        cardInformationView.addGestureRecognizer(recognizer)
        
        divisor = (view.frame.width / 2) / 0.61
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cardView.isHidden = true
        noOffersView.isHidden = false
        
        servicesManager.loadMetaData(completition: { [unowned self] in
            subscribe(forNotification: Notification.Name("offersStartUpdating"))
            subscribe(forNotification: Notification.Name("dataUpdated"))
            
            offersManager.offersQueue.clear()
            displayOffer()
        })
    }
    
    func displayOffer() {
        if let offerPair = offersManager.offersQueue.next() {
            
            offer = offerPair.0
            user = offerPair.1
        }
        if let offer = offer,
           let user = user,
           let category = servicesManager.categories.first(where: {category in return category.id == offer.categoryid}) {
            
            DispatchQueue.main.async {[unowned self] in
                subjectLabel.text = "Category: \(category.name)"
                nameLabel.text = "\(user.lastName) \(user.firstName), \(user.age)"
                descriptionLabel.text = user.userDescription == "" || user.userDescription == "" ? "No Description" : user.userDescription
                costLabel.text = "Price: \(offer.price)₽"
                if let image = user.image {
                    cardImageView.image = image
                } else {
                    cardImageView.image = UIImage(named: "noimage")
                }
                cardView.isHidden = false
                noOffersView.isHidden = true
                resetCard()
            }
        } else {
            
            DispatchQueue.main.async {[unowned self] in
                cardView.isHidden = true
                noOffersView.isHidden = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribe(fromNotification: Notification.Name("dataUpdated"))
        unsubscribe(fromNotification: Notification.Name("offersStartUpdating"))
        
        offersManager.offersQueue.deinitSearch()
        offersManager.offersQueue.clear()
    }
    
    func subscribe(forNotification name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_:)), name: name, object: nil)
    }
    
    func unsubscribe(fromNotification name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    @objc
    func tapHandler(_ recognizer: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "fullInfoSegue", sender: nil)
    }
    
    @objc
    func notificationHandler(_ notification: Notification) {
        
        if notification.name.rawValue == "dataUpdated" {
            displayOffer()
            
        } else if notification.name.rawValue == "offersStartUpdating"{
            
            DispatchQueue.main.async {[unowned self] in
                cardView.isHidden = true
                noOffersView.isHidden = false
            }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "filtersSegue" {
            
            if let destination = segue.destination as? FilterEditorViewController {
                
                offersManager.offersQueue.deinitSearch()
                destination.updateClosure = {[unowned self] in
                    offersManager.offersQueue.clear()
                    displayOffer()
                }
                destination.filter = offersManager.offersQueue.filter
            }
        } else if segue.identifier == "fullInfoSegue" {
            
            if let destination = segue.destination as? FullInfoViewController {
                
                destination.offer = offer
                destination.user = user
            }
        }
        
    }
    
    @IBAction func setFilters(_ sender: Any) {
        
        performSegue(withIdentifier: "filtersSegue", sender: nil)
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
                dislike()
            }
            else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 1, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 85)
                    card.alpha = 0
                })
                generator.prepare()
                generator.impactOccurred()
                like()
                
            } else {
                
                resetCard()
            }
        }
    }
    
    func like() {
        
        guard let url = URL(string: "\(globalManager.apiURL)/offers/\(offer?.id ?? -1)/react/") else {
            resetCard()
            return
        }
        
        if let jsonData = globalManager.reactJSON(from: offersManager.offersQueue.filter, status: "Like") {
            
            globalManager.POST(url: url, data: jsonData, withSerializer: nil, isAuthorized: true, completition: {[unowned self] in
                
                offer = nil
                user = nil
                resetCard()
                displayOffer()
            })
            
        } else {
            
            resetCard()
        }
    }
    
    func dislike() {
        
        guard let url = URL(string: "\(globalManager.apiURL)/offers/\(offer?.id ?? -1)/react/") else {
            resetCard()
            return
        }
        
        if let jsonData = globalManager.reactJSON(from: offersManager.offersQueue.filter, status: "Dislike") {
            
            globalManager.POST(url: url, data: jsonData, withSerializer: nil, isAuthorized: true, completition: {[unowned self] in
                
                offer = nil
                user = nil
                resetCard()
                displayOffer()
            })
            
        } else {
            
            resetCard()
        }
    }
    
    func resetCard() {
        
        UIView.animate(withDuration: 0.5, animations: {[unowned self] in
            
            DispatchQueue.main.async {
                cardView.center = view.center
                cardView.alpha = 1
                cardView.transform = .identity
                likedislikeImageView.alpha = 0
                blurView.alpha = 0
            }
        })
    }
}
