//
//  DialogTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 01.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class DialogTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentFullnameLabel: UILabel!
    @IBOutlet weak var dialogLastMessageLabel: UILabel!
    
    static let identifier = "DialogTableViewCell"
    var dialog: DialogStruct!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI() {
        
        backgroundCellView.layer.cornerRadius = 10
        
        backgroundCellView.layer.shadowColor = UIColor.black.cgColor
        backgroundCellView.layer.shadowOffset = .zero
        backgroundCellView.layer.shadowOpacity = 0.5
        backgroundCellView.layer.shadowRadius = 10
        
        opponentImageView.layer.cornerRadius = opponentImageView.frame.width / 2
    }
    
    func setCell(_ dialog: DialogStruct) {
        
        self.dialog = dialog
        opponentImageView.image = dialog.opponentImage
        opponentFullnameLabel.text = dialog.opponentFullname
        if dialog.messages.count != 0 {
            dialogLastMessageLabel.text =
            dialog.messages[dialog.messages.count - 1].isIncoming ?
                "Opp: \(dialog.messages[dialog.messages.count - 1].text)" :
                "You: \(dialog.messages[dialog.messages.count - 1].text)"
        } else {
            dialogLastMessageLabel.text = ""
        }
        
    }
}
