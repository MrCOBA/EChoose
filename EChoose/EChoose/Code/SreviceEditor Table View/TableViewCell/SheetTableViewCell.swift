//
//  SheetTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 01.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class SheetTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var multipleSelectionTableView: UITableView!
    
    var servicesManager: ServicesManager = ServicesManager.shared
    var serviceDefault: ServiceDefault?
    var delegate: TransferDelegate?
    var data: [String] = []
    var selectedIDs: [Int] = []
    
    static let identifier = "SheetTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
        
        multipleSelectionTableView.delegate = self
        multipleSelectionTableView.dataSource = self
        
        multipleSelectionTableView.register(UINib(nibName: MultipleSelectionCell.identifier, bundle: nil), forCellReuseIdentifier: MultipleSelectionCell.identifier)
    }
    
    func setCell(_ name: String, _ data: [String]) {
        
        cellNameLabel.text = name
        self.data = data
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
    }
}
extension SheetTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = multipleSelectionTableView.dequeueReusableCell(withIdentifier: MultipleSelectionCell.identifier, for: indexPath) as! MultipleSelectionCell
        
        cell.setUpCell(data[indexPath.row], indexPath.row)
        
        
        
        if let serviceDefault = serviceDefault{
            let serviceTypes = servicesManager.serviceTypes.filter({serviceType in return serviceDefault.types.contains(serviceType.id)})
            
            for serviceType in serviceTypes {
                if data[indexPath.row] == serviceType.name {
                    cell.changeState(for: true)
                    break
                }
            }
        }
        cell.delegate = self
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
}
extension SheetTableViewCell: MultipleSelectioDelegate {
    
    func select(_ id: Int) {
        
        if let serviceDefault = serviceDefault {
            
            if let serviceType = servicesManager.serviceTypes.first(where: {serviceType in return serviceType.name == data[id]}) {
                
                if !serviceDefault.types.contains(serviceType.id) {
                    serviceDefault.types.append(serviceType.id)
                }
            }
        }
    }
    
    func deselect(_ id: Int) {
        
        if let serviceDefault = serviceDefault {
            
            if let serviceType = servicesManager.serviceTypes.first(where: {serviceType in return serviceType.name == data[id]}) {
                
                for (index, id) in serviceDefault.types.enumerated() {
                    
                    if id == serviceType.id {
                        serviceDefault.types.remove(at: index)
                        break
                    }
                }
            }
        }
    }
}
