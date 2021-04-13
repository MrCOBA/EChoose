//
//  MyServicesViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 25.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit
import CoreData

class MyServicesViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var myServicesTableView: UITableView!
    let loadingVC: LoadingViewController = LoadingViewController()
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {}
    
    var dataManager: GlobalManager = GlobalManager.shared
    var servicesManager: ServicesManager = ServicesManager.shared
    var locationsManager: LocationsManager = LocationsManager.shared
    var segueData: Any?
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myServicesTableView.delegate = self
        myServicesTableView.dataSource = self
        
        myServicesTableView.register(UINib(nibName: ServiceTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ServiceTableViewCell.identifier)
        
        myServicesTableView.rowHeight = UITableView.automaticDimension
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayContentController(content: loadingVC)
        
        loadData()
        
        servicesManager.loadData(completition: {[unowned self] in
            servicesManager.loadMetaData(completition: {
                DispatchQueue.main.async {[unowned self] in

                    hideContentController(content: loadingVC)
                    myServicesTableView.reloadData()
                }
            })
        })
    }
    
    func displayContentController(content: UIViewController) {
        tabBarController?.addChild(content)
        tabBarController?.view.addSubview(content.view)
        content.didMove(toParent: tabBarController)
    }
    
    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    
    //MARK: - Setting up UI
    func setUI(){
        
        self.overrideUserInterfaceStyle = .light
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        myServicesTableView.layer.cornerRadius = 20
        myServicesTableView.separatorStyle = .none
    }

    func loadData() {
        
        if let user = dataManager.user, let profile = user.profile {
            self.profile = profile
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "serviceEditorSegue" {
            
            if let destination = segue.destination as? ServiceEditorViewController,
               let editorParams = segueData as? (EditorMode, Int) {
                
                destination.editorMode = editorParams.0
                
                if editorParams.0 == EditorMode.edit {
                    if let service = profile?.services?[editorParams.1] as? Service {
                        destination.serviceDefault = servicesManager.defaultCopy(of: service)
                        destination.index = editorParams.1
                    }
                }
            }
        } else {
            
            if let destination = segue.destination as? ServiceViewController,
               let serviceDefault = segueData as? ServiceDefault {
                let subtitle = serviceDefault.isTutor ? "Tutor" : "Student"
                destination.setViewController("My Service", subtitle, serviceDefault)
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        segueData = (EditorMode.new, -1)
        performSegue(withIdentifier: "serviceEditorSegue", sender: nil)
    }
    
    
}
extension MyServicesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let services = profile?.services {
            return services.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myServicesTableView.dequeueReusableCell(withIdentifier: ServiceTableViewCell.identifier, for: indexPath) as! ServiceTableViewCell
        
        cell.backgroundView = UIView()
        cell.backgroundColor = .clear
        
        if let service = profile?.services?[indexPath.row] as? Service {
            
            let defaultCopy = servicesManager.defaultCopy(of: service)
            cell.setCell(defaultCopy)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let service = profile?.services?[indexPath.row] as? Service else {
            return
        }
        let defaultCopy = servicesManager.defaultCopy(of: service)
        
        segueData = defaultCopy
        performSegue(withIdentifier: "popOverService", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        return UISwipeActionsConfiguration(actions: [activationContextualAction(forRowAt: indexPath)])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        return UISwipeActionsConfiguration(actions: [editContextualAction(forRowAt: indexPath), deleteContextualAction(forRowAt: indexPath)])
    }
    
    private func activationContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {

        let action: UIContextualAction!
        
        guard let user = dataManager.user,
              let profile = user.profile,
              let services = profile.services,
              let service = services[indexPath.row] as? Service else {
            return UIContextualAction()
        }
        
        if service.isActive {

            action = UIContextualAction(
                style: .normal,
                title: "Deactivate",
                handler: {[unowned self] (
                    contextualAction: UIContextualAction,
                    swipeButton: UIView,
                    completionHandler: (Bool) -> Void) in

                    let defaultCopy = servicesManager.defaultCopy(of: service)
                    defaultCopy.isActive = false
                    servicesManager.replaceService(defaultCopy, with: indexPath.row, completition: {
                        DispatchQueue.main.async {
                            if let cell = myServicesTableView.cellForRow(at: indexPath) as? ServiceTableViewCell {
                                cell.serviceDefault = defaultCopy
                                cell.changeState()
                            }
                        }
                    })
                    completionHandler(true)
                })
            action.image = UIImage(named: "visibilityoff")
            action.backgroundColor = UIColor(named: "ClearColor")
            return action
        }
        else {
            action = UIContextualAction(
                style: .normal,
                title: "Activate",
                handler: {[unowned self](
                    contextualAction: UIContextualAction,
                    swipeButton: UIView,
                    completionHandler: (Bool) -> Void) in

                    let defaultCopy = servicesManager.defaultCopy(of: service)
                    defaultCopy.isActive = true
                    servicesManager.replaceService(defaultCopy, with: indexPath.row, completition: {
                        DispatchQueue.main.async {
                            if let cell = myServicesTableView.cellForRow(at: indexPath) as? ServiceTableViewCell {
                                cell.serviceDefault = defaultCopy
                                cell.changeState()
                            }
                        }
                    })
                    completionHandler(true)
                })
            action.image = UIImage(named: "visibility")
            action.backgroundColor = UIColor(named: "ClearColor")
            return action
        }
    }

    private func deleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(
            style: .normal,
            title: "Delete",
            handler: {[unowned self](
                contextualAction: UIContextualAction,
                swipeButton: UIView,
                completionHandler: (Bool) -> Void) in

                guard let id = servicesManager.index2id(indexPath.row) else {
                    return
                }
                
                servicesManager.deleteService(with: id, completition: {
                    
                    DispatchQueue.main.async {
                        self.myServicesTableView.deleteRows(at: [indexPath], with: .fade)
                    }
                })
                
                completionHandler(true)
            })
        action.image = UIImage(named: "bin")
        action.backgroundColor = UIColor(named: "ClearColor")
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
                
                self.segueData = (EditorMode.edit, indexPath.row)
                self.performSegue(withIdentifier: "serviceEditorSegue", sender: nil)
                completionHandler(true)
            })
        action.image = UIImage(named: "edit")
        action.backgroundColor = UIColor(named: "ClearColor")
        return action
    }
}
