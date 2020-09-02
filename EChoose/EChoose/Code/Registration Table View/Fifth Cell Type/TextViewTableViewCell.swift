//
//  TextViewTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 24.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class TextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    static let identifier = "TextViewTableViewCell"
    private var cellName: String!
    var superTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionTextView.delegate = self
        
        setUI()
    }
    
    func setCell(_ cellName: String, _ superTableView: UITableView) {
        
        self.cellName = cellName
        cellNameLabel.text = cellName
        self.superTableView = superTableView
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHandler))
        
        superTableView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
        
        descriptionView.layer.cornerRadius = 10
    }
    
    @objc
    func touchHandler(_ recognizer: UITapGestureRecognizer) {
        
        descriptionTextView.resignFirstResponder()
    }
}
extension TextViewTableViewCell: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        self.descriptionView.resignFirstResponder()
        return true
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        
        descriptionTextView.resignFirstResponder()
        return true
    }
}
