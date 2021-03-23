//
//  ButtonTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 16.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

protocol ActionDelegate {

    func actionHandler()
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: CustomButton!
    
    static let identifier = "ButtonTableViewCell"
    var delegate: ActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        delegate?.actionHandler()
    }
    
}
