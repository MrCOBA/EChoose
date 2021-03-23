//
//  ListTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 21.02.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

protocol AddressListDelegate {
    
    func perform(at index: Int)
}

class ListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet var backViews: [CustomView]!
    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet var addressLabels: [UILabel]!
    @IBOutlet var addButtons: [UIButton]!
    @IBOutlet var clearButtons: [UIButton]!
    
    
    static let identifier: String = "ListTableViewCell"
    var delegate: AddressListDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setCell(_ title: String, with addresses: [String] = ["No address", "No address", "No address"]) {
        
        cellNameLabel.text = title
        
        for (i, label) in addressLabels.enumerated() {
            
            label.text = addresses[i]
        }
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
    }
    
    @IBAction func addAddress(_ sender: Any) {
        
        guard let senderButton = sender as? UIButton else {
            return
        }
        
        for (i, button) in addButtons.enumerated() {
            
            if senderButton == button {
                
                delegate?.perform(at: i)
            }
        }
    }
    
    @IBAction func clearAddress(_ sender: Any) {
        
        guard let senderButton = sender as? UIButton else {
            return
        }
        
        for (i, button) in clearButtons.enumerated() {
            
            if senderButton == button {
                
                addressLabels[i].text = "No address"
                backViews[i].backgroundColor = UIColor(named: "MainColor")
                addressLabels[i].textColor = UIColor(named: "SecondColorGradient")
                addButtons[i].tintColor = UIColor(named: "SecondColorGradient")
            }
        }
    }
    
}
