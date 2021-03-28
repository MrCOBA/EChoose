//
//  ProfileTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 28.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var profileImageView: CustomImageView!
    
    static let identifier = "ProfileTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }

    func setUI() {
        
        backgroundCellView.layer.cornerRadius = 5
        backgroundCellView.layer.shadowColor = UIColor.black.cgColor
        backgroundCellView.layer.shadowOffset = .zero
        backgroundCellView.layer.shadowRadius = 5
        backgroundCellView.layer.shadowOpacity = 0.5
    }
    
    func setCell(_ image: UIImage, _ value: String) {
        
        profileImageView.image = image
        valueLabel.text = value
    }
    
}
