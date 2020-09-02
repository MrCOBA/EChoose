//
//  SectionHeader.swift
//  EChoose
//
//  Created by Oparin Oleg on 25.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class SectionHeader: UITableViewCell {

    @IBOutlet weak var sectionNameLabel: UILabel!
    
    static let identifier = "SectionHeader"
    private var sectionName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setHeader(_ sectionName: String) {
        
        self.sectionName = sectionName
        sectionNameLabel.text = sectionName
    }
}
