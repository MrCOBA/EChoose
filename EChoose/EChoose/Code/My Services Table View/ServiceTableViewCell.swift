//
//  ServiceTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 28.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit
import CoreData

class ServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var stateIndicator: UIImageView!
    
    var service: Service!
    static let identifier = "ServiceTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    private func setUI() {
        
        backgroundCellView.layer.cornerRadius = 20
        
        backgroundCellView.layer.shadowColor = UIColor.black.cgColor
        backgroundCellView.layer.shadowOffset = .zero
        backgroundCellView.layer.shadowRadius = 5
        backgroundCellView.layer.shadowOpacity = 0.5
    }
    
    func setCell(_ service: Service!) {
        
        self.service = service
        
        subjectLabel.text = service.subject
        workTypeLabel.text = service.type
        costLabel.text = "\(service.cost)₽"
        
        for i in 0...4 {
            
            if i < service.hard {
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
