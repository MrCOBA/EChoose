//
//  DoublePickerCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 07.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class DoublePickerCell: UITableViewCell {

    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var data: [[String:[String]]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        initData()
    }
    
    private func initData() {
        
        if let path = Bundle.main.path(forResource: "Countries&Cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: [])
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let json = json as? [[String: [String]]] {
                    self.data = json
                }
            } catch {
                print("Error!")
            }
        }
    }
}
extension DoublePickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return data.count
        } else {
            
            let index = pickerView.selectedRow(inComponent: 0)
            return data[index].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return data[row].keys.first
        }
        else {
            let selectedCountry = pickerView.selectedRow(inComponent: 0)
            return data[selectedCountry].values.first![row]
        }
    }
    
    
}
