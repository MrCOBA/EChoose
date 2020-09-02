//
//  BigServiceTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 29.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class BigServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var stateIndicator: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var service: ServiceStruct!
    static let identifier = "BigServiceTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    private func setUI() {
        
        backView.layer.cornerRadius = 10
        
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = .zero
        backView.layer.shadowRadius = 5
        backView.layer.shadowOpacity = 0.5
    }
    
    func setCell(_ service: ServiceStruct!) {
        
        self.service = service
        
        subjectLabel.text = service.subject
        workTypeLabel.text = service.typeOfWork
        costLabel.text = "\(service.cost)₽"
        descriptionLabel.text = service.description
        
        for i in 0...4 {
            
            if i < service.hardLevel {
                (ratingStackView.subviews[i] as! UIButton).setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
            }
            else {
                (ratingStackView.subviews[i] as! UIButton).setBackgroundImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        
        if service.isActivated {
            
            stateIndicator.image = UIImage(named: "activatedstate")
            stateIndicator.tintColor = #colorLiteral(red: 0.5009238996, green: 1, blue: 0.4745031706, alpha: 1)
        }
        else {
            
            stateIndicator.image = UIImage(named: "unactivatedstate")
            stateIndicator.tintColor = #colorLiteral(red: 1, green: 0.400758059, blue: 0.3482903581, alpha: 1)
        }
    }
    
    func changeState() {
        
        service.isActivated = !service.isActivated
        
        if service.isActivated {
            
            stateIndicator.image = UIImage(named: "activatedstate")
            stateIndicator.tintColor = #colorLiteral(red: 0.5009238996, green: 1, blue: 0.4745031706, alpha: 1)
        }
        else {
            
            stateIndicator.image = UIImage(named: "unactivatedstate")
            stateIndicator.tintColor = #colorLiteral(red: 1, green: 0.400758059, blue: 0.3482903581, alpha: 1)
        }
    }
    
}
