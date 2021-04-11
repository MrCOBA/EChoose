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
    @IBOutlet weak var opponentImageView: CustomImageView!
    @IBOutlet weak var opponentFullnameLabel: UILabel!
    @IBOutlet weak var dialogLastMessageLabel: UILabel!
    
    static let identifier = "DialogTableViewCell"
    var dialog: DialogDefault?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI() {
        
        backgroundCellView.layer.cornerRadius = 20
    }
    
    func setCell(_ dialog: DialogDefault?) {
        
        self.dialog = dialog
        opponentImageView.image = dialog?.userDefault?.image ?? UIImage(named: "noimage")
        opponentFullnameLabel.text = "\(dialog?.userDefault?.lastName ?? "") \(dialog?.userDefault?.firstName ?? "")"
        if let lastMessage = dialog?.lastMessage {
            dialogLastMessageLabel.text = lastMessage.isIncoming ?
                "\(dialog?.userDefault?.firstName ?? ""): \(lastMessage.text)" : "You: \(lastMessage.text)"
        } else {
            dialogLastMessageLabel.text = "No messages"
        }
        
    }
}
