//
//  MessageTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 31.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLeadingConstraint: NSLayoutConstraint!
    
    
    static let identifier = "MessageTableViewCell"
    var message: MessageStruct!
    var formatter: DateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leadingConstraint.constant = 16
        trailingConstraint.constant = 16
        formatter.dateFormat = "HH:mm a"
    }
    
    func setCell(_ message: MessageStruct) {
        
        self.message = message
        
        if leadingConstraint != nil {
            leadingConstraint.isActive = message.isIncoming
        }
        if trailingConstraint != nil {
            trailingConstraint.isActive = !message.isIncoming
        }
        if dateLeadingConstraint != nil {
            dateLeadingConstraint.isActive = message.isIncoming
        }
        if dateTrailingConstraint != nil {
            dateTrailingConstraint.isActive = !message.isIncoming
        }
        
        backgroundCellView.layer.cornerRadius = 15
        backgroundCellView.backgroundColor = message.isIncoming ? #colorLiteral(red: 0.3810000122, green: 0.7239999771, blue: 1, alpha: 1) : #colorLiteral(red: 0.960748136, green: 0.9848688245, blue: 0.4547813535, alpha: 1)
        messageTextLabel.textColor = message.isIncoming ? .white : .black
        timeLabel.textAlignment = message.isIncoming ? .left : .right
        messageTextLabel.text = message.text
        timeLabel.text = formatter.string(from: message.time)
    }
}
