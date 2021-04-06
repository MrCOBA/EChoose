//
//  ChatMessageCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 24.02.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {

    let messageLabel = UILabel()
    let dateLabel: UILabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var messageLeadingConstraint: NSLayoutConstraint!
    var messageTrailingConstraint: NSLayoutConstraint!
    var dateLeadingConstraint: NSLayoutConstraint!
    var dateTrailingConstraint: NSLayoutConstraint!
    
    static let identifier = "ChatMessageCell"
    
    var chatMessage: MessageStruct! {
        didSet {
            bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? UIColor(named: "SecondColor") : UIColor(named: "FirstColorGradient")
            messageLabel.textColor = chatMessage.isIncoming ? .white : .black
            dateLabel.textColor = chatMessage.isIncoming ? .white : .black
            
            messageLabel.text = chatMessage.text
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "dd MMM, HH:mm a"
            dateLabel.text = formatter.string(from: chatMessage.time)
            
            if chatMessage.isIncoming {
                messageLeadingConstraint.isActive = true
                messageTrailingConstraint.isActive = false
                dateLeadingConstraint.isActive = true
                dateTrailingConstraint.isActive = false
            } else {
                messageLeadingConstraint.isActive = false
                messageTrailingConstraint.isActive = true
                dateLeadingConstraint.isActive = false
                dateTrailingConstraint.isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)
        
        addSubview(messageLabel)
        addSubview(dateLabel)
        
        messageLabel.numberOfLines = 0
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)!
        dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 7)!
        
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            dateLabel.heightAnchor.constraint(equalToConstant: 10),
            dateLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 2),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 7),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            ]
        NSLayoutConstraint.activate(constraints)
        
        messageLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        messageLeadingConstraint.isActive = false
        
        messageTrailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        messageTrailingConstraint.isActive = true
        
        dateLeadingConstraint = dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        dateLeadingConstraint.isActive = false
        
        dateTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        dateTrailingConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
