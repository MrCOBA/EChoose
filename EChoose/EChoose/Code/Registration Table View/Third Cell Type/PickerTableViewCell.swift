//
//  PickerTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 23.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var dataPicker: UIPickerView!
    
    static let identifier = "PickerTableViewCell"
    private var data: [String] = []
    private var cellName: String!
    var superTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        dataPicker.delegate = self
        dataPicker.dataSource = self
        setUI()
    }
    
    func setCell(_ cellName: String, _ data: [String]) {
        
        self.cellName = cellName
        self.data = data
        cellNameLabel.text = cellName
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
    }
}
extension PickerTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 1 {
            RegistrationSectionsSizes.thirdSection = 3
            superTableView.reloadData()
            let indexPath = NSIndexPath(row: 2, section: 2)
            superTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
        else {
            RegistrationSectionsSizes.thirdSection = 4
            superTableView.reloadData()
            let indexPath = NSIndexPath(row: 3, section: 2)
            superTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
    }
}
