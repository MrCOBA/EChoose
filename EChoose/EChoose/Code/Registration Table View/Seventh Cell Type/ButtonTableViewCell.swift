//
//  ButtonTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 16.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    
    static let identifier = "ButtonTableViewCell"
    var registrationController: RegistrationViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }

    func setUI() {
        
        backgroundCellView.layer.cornerRadius = 10
        
        backgroundCellView.layer.shadowColor = UIColor.black.cgColor
        backgroundCellView.layer.shadowOffset = .zero
        backgroundCellView.layer.shadowOpacity = 0.5
        backgroundCellView.layer.shadowRadius = 5
        
        button.layer.cornerRadius = 10
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
    }
    
    func setCell(_ name: String, _ registrationController: RegistrationViewController) {
        
        cellNameLabel.text = name
        self.registrationController = registrationController
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        registrationController.performSegue(withIdentifier: "mapSegue", sender: nil)
    }
    
}
