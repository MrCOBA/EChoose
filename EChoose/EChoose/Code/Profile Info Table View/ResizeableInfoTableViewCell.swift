//
//  DescriptionTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 08.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class ResizeableInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var attributeImageView: UIImageView!
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    static let identifier = "ResizeableInfoTableViewCell"
    
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
    
    func setCell(_ image: UIImage, _ name: String, _ value: String) {
        
        attributeImageView.image = image
        attributeLabel.text = "\(name): "
        valueLabel.text = "\(value)"
    }
}
