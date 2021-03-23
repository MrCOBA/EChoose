//
//  MyLocationsViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 03.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit
import MapKit

class MyLocationsViewController: UIViewController {

    @IBOutlet weak var myLocationsTableView: UITableView!
    
    var serviceDefault: ServiceDefault?
    var transferData: (EditorMode, LocationDefault)?
    var data: [LocationDefault] = []
    var globalManager: GlobalManager = GlobalManager.shared
    var locationsManaher: LocationsManager = LocationsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myLocationsTableView.layer.cornerRadius = 20
        
        myLocationsTableView.delegate = self
        myLocationsTableView.dataSource = self
        
        navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "MainColor")
        
        myLocationsTableView.register(UINib(nibName: MapLocationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MapLocationTableViewCell.identifier)
        myLocationsTableView.register(UINib(nibName: NewMapLocationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewMapLocationTableViewCell.identifier)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myLocationsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? MapViewController else {
            return
        }
        if let transferData = transferData {
            destination.editorMode = transferData.0
            destination.editingLocation = transferData.1
        }
        
        destination.delegate = self
    }
}
extension MyLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsManaher.locationsDefault.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = myLocationsTableView.dequeueReusableCell(withIdentifier: NewMapLocationTableViewCell.identifier, for: indexPath) as! NewMapLocationTableViewCell
            
            cell.delegate = self
            return cell
        }
        
        let cell = myLocationsTableView.dequeueReusableCell(withIdentifier: MapLocationTableViewCell.identifier, for: indexPath) as! MapLocationTableViewCell
        
        cell.setCell(locationsManaher.locationsDefault[indexPath.row - 1])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let serviceDefault = serviceDefault,
           let id = locationsManaher.locationsDefault[indexPath.row - 1].id {
            
            serviceDefault.addressid = id
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.row == 0 {
            return UISwipeActionsConfiguration()
        }
        return UISwipeActionsConfiguration(actions: [deleteContextualAction(forRowAt: indexPath)])
    }
    
    private func deleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(
            style: .normal,
            title: "Delete",
            handler: {[unowned self] (
                contextualAction: UIContextualAction,
                swipeButton: UIView,
                completionHandler: (Bool) -> Void) in

                guard let id = locationsManaher.index2id(indexPath.row - 1) else {
                    return
                }
                locationsManaher.deleteLocation(with: id, completition: {
                    DispatchQueue.main.async {
                        myLocationsTableView.deleteRows(at: [indexPath], with: .fade)
                    }
                })
                completionHandler(true)
            })
        action.backgroundColor = #colorLiteral(red: 1, green: 0.400758059, blue: 0.3482903581, alpha: 1)
        return action
    }
    
}
extension MyLocationsViewController: SegueDelegate, MapControllerDelegate{
    
    func add(_ locationDefault: LocationDefault) {
        data.append(locationDefault)
        myLocationsTableView.reloadData()
    }
    
    func replace(_ locationDefault: LocationDefault, _ index: Int){
        data[index] = locationDefault
        myLocationsTableView.reloadData()
    }
    
    func reload() {
        myLocationsTableView.reloadData()
    }
    
    func perform(segue identifier: String, data: [Any]?, sender: Any?) {
        
        if let data = data, let transferData = data.first as? (EditorMode, LocationDefault){
            self.transferData = transferData
        } else {
            self.transferData = nil
        }
        performSegue(withIdentifier: identifier, sender: sender)
    }
}
