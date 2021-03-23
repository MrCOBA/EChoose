//
//  NewMapLocationTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 03.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class NewMapLocationTableViewCell: UITableViewCell {

    static let identifier = "NewMapLocationTableViewCell"
    
    var delegate: SegueDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    @IBAction func addNewLocation(_ sender: Any) {
        
        delegate?.perform(segue: "locationEditorSegue", data: nil, sender: nil)
    }
}
