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
    var delegate: TransferDelegate?
    private var cellName: String!
    private var key = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        setUI()
    }
    
    func setCell(_ cellName: String, _ pair: (String, String)) {
        self.key = pair.0
        
        if pair.1 != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: pair.1) {
                datePicker.setDate(date, animated: true)
            }
        }
        
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
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: picker.date)
        
        delegate?.transferData(for: key, with: date)
    }
}
