//
//  TextViewTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 24.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

protocol GestureDelegate {
    
    func addGestureRecognizer(_ recognizer: UITapGestureRecognizer)
}

class TextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    static let identifier = "TextViewTableViewCell"
    var serviceManager: ServicesManager = ServicesManager.shared
    var serviceDefault: ServiceDefault?
    var delegate: TransferDelegate?
    var gestureDelegate: GestureDelegate?
    var notificationCenter: NotificationCenter!
    private var key: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionTextView.delegate = self
        
        setUI()
    }
    
    func setCell(_ cellName: String, _ key: String) {
        self.key = key
        cellNameLabel.text = cellName
        
        if let serviceDefault = serviceDefault {
            
            descriptionTextView.text = serviceDefault.description
        }
        
        notificationCenter = NotificationCenter.default
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHandler))
        gestureDelegate?.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
        
    }
    
    @objc
    func touchHandler(_ recognizer: UITapGestureRecognizer) {
        
        descriptionTextView.resignFirstResponder()
        if let serviceDefault = serviceDefault {
            serviceDefault.description = descriptionTextView.text
            return
        }
        delegate?.transferData(for: key, with: descriptionTextView.text)
    }
}
extension TextViewTableViewCell: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        self.descriptionTextView.resignFirstResponder()
        return true
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        
        descriptionTextView.resignFirstResponder()
        return true
    }
}
