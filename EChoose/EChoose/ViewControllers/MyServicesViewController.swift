//
//  MyServicesViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 25.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

struct ServiceStruct {
    
    var subject: String
    var typeOfWork: String
    var isActivated: Bool = true
    var cost: Int
    var description: String
    var hardLevel: Int
}

class MyServicesViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var myServicesTableView: UITableView!
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {}
    
    var services: [ServiceStruct] = []
    var mode: EditorMode! = .none
    var row: Int = 0
    var highlitedRow: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myServicesTableView.delegate = self
        myServicesTableView.dataSource = self
        
        myServicesTableView.register(UINib(nibName: ServiceTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ServiceTableViewCell.identifier)
        myServicesTableView.register(UINib(nibName: BigServiceTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BigServiceTableViewCell.identifier)
        
        myServicesTableView.rowHeight = UITableView.automaticDimension
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        highlitedRow = nil
        myServicesTableView.reloadData()
    }
    //MARK: - Setting up UI
    func setUI(){
        
        self.overrideUserInterfaceStyle = .light
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //Set table view layer
        myServicesTableView.layer.cornerRadius = 10
        myServicesTableView.separatorStyle = .none
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! ServiceEditorViewController
        
        destination.servicesController = self
        destination.mode = mode
        if mode == EditorMode.editService {
            destination.service = services[row]
            destination.row = row
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        mode = EditorMode.newService
        performSegue(withIdentifier: "serviceEditorSegue", sender: nil)
    }
    
    
}
extension MyServicesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == highlitedRow {
            let cell = myServicesTableView.dequeueReusableCell(withIdentifier: BigServiceTableViewCell.identifier, for: indexPath) as! BigServiceTableViewCell
            cell.setCell(services[indexPath.row])
            return cell
        }
        let cell = myServicesTableView.dequeueReusableCell(withIdentifier: ServiceTableViewCell.identifier, for: indexPath) as! ServiceTableViewCell
        cell.setCell(services[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == highlitedRow {
            highlitedRow = nil
        } else {
            highlitedRow = indexPath
        }
        myServicesTableView.reloadData()
        UIView.transition(
            with: tableView,
            duration: 0.7,
            options: .transitionCrossDissolve,
            animations: {self.myServicesTableView.reloadData()},
            completion: nil)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        return UISwipeActionsConfiguration(actions: [activationContextualAction(forRowAt: indexPath)])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        return UISwipeActionsConfiguration(actions: [editContextualAction(forRowAt: indexPath), deleteContextualAction(forRowAt: indexPath)])
    }
    
    private func activationContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        
        let action: UIContextualAction!
        
        if services[indexPath.row].isActivated {
            
            action = UIContextualAction(
                style: .normal,
                title: "Unactivate",
                handler: {(
                    contextualAction: UIContextualAction,
                    swipeButton: UIView,
                    completionHandler: (Bool) -> Void) in
                    
                    self.services[indexPath.row].isActivated = false
                    if indexPath != self.highlitedRow {
                        let cell =  self.myServicesTableView.cellForRow(at: indexPath) as! ServiceTableViewCell
                        cell.changeState()
                    } else {
                        let cell =  self.myServicesTableView.cellForRow(at: indexPath) as! BigServiceTableViewCell
                        cell.changeState()
                    }
                    completionHandler(true)
                })
            action.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.7259845769, blue: 0.3343080493, alpha: 1)
            return action
        }
        else {
            action = UIContextualAction(
                style: .normal,
                title: "Activate",
                handler: {(
                    contextualAction: UIContextualAction,
                    swipeButton: UIView,
                    completionHandler: (Bool) -> Void) in
                    
                    self.services[indexPath.row].isActivated = true
                    if indexPath != self.highlitedRow {
                        let cell =  self.myServicesTableView.cellForRow(at: indexPath) as! ServiceTableViewCell
                        cell.changeState()
                    } else {
                        let cell =  self.myServicesTableView.cellForRow(at: indexPath) as! BigServiceTableViewCell
                        cell.changeState()
                    }
                    completionHandler(true)
                })
            action.backgroundColor = #colorLiteral(red: 0.3808822285, green: 0.7240369789, blue: 1, alpha: 1)
            return action
        }
    }
    
    private func deleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(
            style: .normal,
            title: "Delete",
            handler: {(
                contextualAction: UIContextualAction,
                swipeButton: UIView,
                completionHandler: (Bool) -> Void) in
                
                self.services.remove(at: indexPath.row)
                self.myServicesTableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            })
        action.backgroundColor = #colorLiteral(red: 1, green: 0.400758059, blue: 0.3482903581, alpha: 1)
        return action
    }
    
    private func editContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(
            style: .normal,
            title: "Edit",
            handler: {(
                contextualAction: UIContextualAction,
                swipeButton: UIView,
                completionHandler: (Bool) -> Void) in
                
                self.mode = EditorMode.editService
                self.row = indexPath.row
                self.performSegue(withIdentifier: "serviceEditorSegue", sender: nil)
                completionHandler(true)
            })
        action.backgroundColor = #colorLiteral(red: 0.5009238996, green: 1, blue: 0.4745031706, alpha: 1)
        return action
    }
}
