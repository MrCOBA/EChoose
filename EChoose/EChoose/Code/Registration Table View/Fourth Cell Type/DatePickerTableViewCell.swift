//
//  DatePickerTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 24.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    static let identifier = "DatePickerTableViewCell"
    private var cellName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setCell(_ cellName: String) {
        
        self.cellName = cellName
        cellNameLabel.text = cellName
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
        
        datePicker.maximumDate = Date()
    }
}
