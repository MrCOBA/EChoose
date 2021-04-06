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
    
    var delegate: TransferDelegate?
    var servicesManager: ServicesManager = ServicesManager.shared
    var serviceDefault: ServiceDefault?
    private var key: String = ""
    private var data: [String] = []
    private var cellName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        dataPicker.delegate = self
        dataPicker.dataSource = self
        setUI()
    }
    
    func setCell(_ cellName: String, _ data: [String], _ key: String) {
        self.key = key
        self.cellName = cellName
        self.data = data
        cellNameLabel.text = cellName
        
        if let serviceDefault = serviceDefault,
           let edLocationType = servicesManager.edLocationTypes.first(where: {edLocationType in return edLocationType == serviceDefault.edLocation}){
            
            for (i, string) in data.enumerated() {
                if string == edLocationType {
                    dataPicker.selectRow(i, inComponent: 0, animated: true)
                }
            }
        }
        
        if serviceDefault?.edLocation == "" {
            serviceDefault?.edLocation = data[0]
        }
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
        if let serviceDefault = serviceDefault {
            serviceDefault.edLocation = data[row]
        }
        delegate?.transferData(for: self.key, with: data[row])
    }
}

