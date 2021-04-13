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
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var stateIndicator: UIImageView!
    
    var servicesManager: ServicesManager = ServicesManager.shared
    var serviceDefault: ServiceDefault?
    static let identifier = "ServiceTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    private func setUI() {
        
        backgroundCellView.layer.cornerRadius = 20
    }
    
    func setCell(_ serviceDefault: ServiceDefault?) {
        
        guard let serviceDefault = serviceDefault else {
            return
        }
        
        self.serviceDefault = serviceDefault
        
        if let category = servicesManager.categories.first(where: {category in return category.id == serviceDefault.categoryid}),
           let edLocationType = servicesManager.edLocationTypes.first(where: {edLocationType in return edLocationType == serviceDefault.edLocation}) {
            
            subjectLabel.text = category.name
            workTypeLabel.text = edLocationType
            costLabel.text = "\(serviceDefault.price)₽"
            roleLabel.text = serviceDefault.isTutor ? "Tutor" : "Student"
        }
        
        if serviceDefault.isActive {
            
            stateIndicator.image = UIImage(named: "activatedstate")
            stateIndicator.tintColor = UIColor(named: "likeGreen")
        }
        else {
            
            stateIndicator.image = UIImage(named: "unactivatedstate")
            stateIndicator.tintColor = UIColor(named: "dislikeColor")
        }
    }
    
    func changeState() {
        
        guard let serviceDefault = serviceDefault else {
            return
        }
        
        if serviceDefault.isActive {
            
            stateIndicator.image = UIImage(named: "activatedstate")
            stateIndicator.tintColor = UIColor(named: "likeGreen")
        }
        else {
            
            stateIndicator.image = UIImage(named: "unactivatedstate")
            stateIndicator.tintColor = UIColor(named: "dislikeColor")
        }
    }
}
