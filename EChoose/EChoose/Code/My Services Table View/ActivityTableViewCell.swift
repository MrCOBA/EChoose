//
//  ActivityTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 29.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var userImageView: CustomImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var firstActionButton: CustomButton!
    @IBOutlet weak var secondActionButton: CustomButton!
    
    static let identifier = "ActivityTableViewCell"
    
    var servicesManager: ServicesManager = ServicesManager.shared
    var offer: Offer?
    var user: OfferUser?
    var delegate: SegueDelegate?
    
    var firstAction: ((Offer?, OfferUser?) -> Void)?
    var secondAction: ((Offer?, OfferUser?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            delegate?.perform(segue: "fullInfoSegue", data: [(offer, user)], sender: nil)
        }
    }
    
    func setUI() {
        
        backgroundCellView.layer.cornerRadius = 20
    }
    
    func setCell(_ offer: Offer?, _ user: OfferUser?) {
        
        guard let offer = offer else {
            return
        }
        guard let user = user else {
            return
        }
        
        self.offer = offer
        self.user = user
        
        fullnameLabel.text = "\(user.lastName) \(user.firstName), \(user.age)"
        userImageView.image = user.image ?? UIImage(named: "noimage")
        
        if let category = servicesManager.categories.first(where: {category in return category.id == offer.categoryid}) {
            
            categoryLabel.text = category.name
        }
        
        roleLabel.text = offer.isTutor ? "Tutor" : "Student"
        priceLabel.text = "\(offer.price)₽"
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        
        if let button = sender as? CustomButton {
            
            if button == firstActionButton {
                
                if let firstAction = firstAction {
                    firstAction(offer, user)
                }
                
            } else if button == secondActionButton {
                
                if let secondAction = secondAction {
                    secondAction(offer, user)
                }
            }
        }
    }
    
}
