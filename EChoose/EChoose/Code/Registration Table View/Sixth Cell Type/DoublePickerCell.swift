//
//  DoublePickerCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 07.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class DoublePickerCell: UITableViewCell {

    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var firstPickerView: UIPickerView!
    @IBOutlet weak var secondPickerView: UIPickerView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    static let identifier = "DoublePickerCell"
    var delegate: TransferDelegate?
    var data: [String:[String]] = [:]
    var countries: [String] = []
    var filteredCountries: [String] = []
    var cities: [[String]] = []
    var filteredCities: [[String]] = []
    private var key = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initData()
        
        searchBar.delegate = self
        firstPickerView.delegate = self
        firstPickerView.dataSource = self
        secondPickerView.delegate = self
        secondPickerView.dataSource = self
        
        setUI()
    }
    
    func setCell(_ cellName: String, _ key: String) {
        self.key = key
        cellNameLabel.text = cellName
    }
    
    private func setUI() {
        
        backgroundCellView.layer.cornerRadius = 10
        
        backgroundCellView.layer.shadowColor = UIColor.black.cgColor
        backgroundCellView.layer.shadowOffset = .zero
        backgroundCellView.layer.shadowOpacity = 0.5
        backgroundCellView.layer.shadowRadius = 5
        
        searchBar.layer.borderWidth = 1;
        searchBar.layer.borderColor = searchBar.tintColor.cgColor
    }
    
    private func initData() {
        
        if let path = Bundle.main.path(forResource: "Countries&Cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: [])
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let json = json as? [String: [String]] {
                    self.data = json
                    for item in json {
                        countries.append(item.key)
                    }
                    countries.sort()
                    
                    for country in countries {
                        cities.append(json[country]!)
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
extension DoublePickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == firstPickerView {
            
            if searchBar.text == "" {
                return countries.count
            } else {
                return filteredCountries.count
            }
        }
        else {
            
            if searchBar.text == "" {
                return cities[firstPickerView.selectedRow(inComponent: 0)].count
            } else {
                if filteredCities.count > 0 {
                    return filteredCities[firstPickerView.selectedRow(inComponent: 0)].count
                }
                else {
                    return 0
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var selectedItem = ""
        if pickerView == firstPickerView {
            if searchBar.text == "" {
                selectedItem = countries[row]
            } else {
                selectedItem = filteredCountries[row]
            }
            return selectedItem
        } else {
            if searchBar.text == "" {
                selectedItem = cities[firstPickerView.selectedRow(inComponent: 0)][row]
            } else {
                selectedItem = filteredCities[firstPickerView.selectedRow(inComponent: 0)][row]
            }
            
            return selectedItem
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == firstPickerView {
            
            secondPickerView.reloadComponent(0)
            secondPickerView.selectRow(0, inComponent: 0, animated: true)
        }
        var selectedCity = ""
        var selectedCountry = ""
        
        if searchBar.text == "" {
            
            selectedCountry = countries[firstPickerView.selectedRow(inComponent: 0)]
            selectedCity = cities[firstPickerView.selectedRow(inComponent: 0)][secondPickerView.selectedRow(inComponent: 0)]
        } else {
            
            selectedCountry = filteredCountries[firstPickerView.selectedRow(inComponent: 0)]
            selectedCity = filteredCities[firstPickerView.selectedRow(inComponent: 0)][secondPickerView.selectedRow(inComponent: 0)]
        }
        delegate?.transferData(for: key, with: "\(selectedCountry) : \(selectedCity)")
    }
}
extension DoublePickerCell: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        DispatchQueue.global(qos: .userInteractive).sync {[unowned self] in
            
            let substring = searchText.lowercased()
            filteredCountries = []
            
            for (i, country) in countries.enumerated() {
                
                for (j, city) in cities[i].enumerated() {
                    
                    let leftElem = city.lowercased()
                    let rightElem = cities[i][cities[i].count - 1 - j] .lowercased()
                    
                    if (leftElem.contains(substring) ||  rightElem.contains(substring)) && j < cities[i].count - j{
                        
                        filteredCountries.append(country)
                        break
                    }
                }
            }
            
            filteredCities = []
            
            for country in filteredCountries {
                
                filteredCities.append(data[country]!.filter({city in
                    return city.lowercased().contains(substring.lowercased())
                }))
            }
            
            DispatchQueue.main.async {
                
                firstPickerView.reloadComponent(0)
                secondPickerView.reloadComponent(0)
                secondPickerView.selectRow(0, inComponent: 0, animated: true)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
