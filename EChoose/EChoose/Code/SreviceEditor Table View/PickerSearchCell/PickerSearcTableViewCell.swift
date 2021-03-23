//
//  PickerSearchCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 01.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class PickerSearcTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var dataPicker: UIPickerView!
    
    var servicesManager: ServicesManager = ServicesManager.shared
    var serviceDefault: ServiceDefault?
    private var data: [String] = []
    private var filteredData: [String] = []
    
    static let identifier = "PickerSearcTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataPicker.delegate = self
        dataPicker.dataSource = self
        setUI()
    }
    
    func setCell(_ cellName: String, _ data: [String]) {
        
        self.data = data
        cellNameLabel.text = cellName
        
        if let serviceDefault = serviceDefault,
           let category = servicesManager.categories.first(where: {category in return category.id == serviceDefault.categoryid}){
            
            for (i, string) in data.enumerated() {
                if string == category.name {
                    dataPicker.selectRow(i, inComponent: 0, animated: true)
                }
            }
        } else {
            
            if let serviceDefault = serviceDefault {
                
                if serviceDefault.categoryid == -1 {
                    serviceDefault.categoryid = servicesManager.categories.first(where: {category in return category.name == data[0]})!.id
                }
            }
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
extension PickerSearcTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if searchBar.text != "" {
            return filteredData.count
        }
        else {
            return data.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if searchBar.text != "" {
            return filteredData[row]
        }
        else {
            return data[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let serviceDefault = serviceDefault {
            
            if let id = servicesManager.categories.first(where: {category in category.name == data[row] })?.id {
                serviceDefault.categoryid = id
            }
        }
        
    }
}
extension PickerSearcTableViewCell: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredData = data.filter{(subject) -> Bool in
            
            return subject.lowercased().contains(searchBar.text!.lowercased())
        }
        
        self.dataPicker.reloadComponent(0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
