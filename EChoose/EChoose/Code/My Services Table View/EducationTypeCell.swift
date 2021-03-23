//
//  EducationTypeCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 14.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class EducationTypeCell: UICollectionViewCell {

    @IBOutlet weak var educationTypeLabel: UILabel!
    
    static var identifier = "EducationTypeCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setCell(_ type: String) {
        
        self.educationTypeLabel.text = type
    }

}
