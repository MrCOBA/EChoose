//
//  ServiceEditorViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 03.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

enum EditorMode: Int {
    
    case new = 0
    case edit
}

struct ServiceEditorSectionsSizes {
    
    static var firstSection: Int = 2
    static var secondSection: Int = 2
    static var thirdSection: Int = 4
}

class ServiceEditorViewController: UIViewController {

    @IBOutlet weak var serviceEditorTableView: UITableView!
    
    var globalManager: GlobalManager = GlobalManager.shared
    var servicesManager: ServicesManager = ServicesManager.shared
    var locationsManager: LocationsManager = LocationsManager.shared
    
    var serviceDefault: ServiceDefault?
    var index: Int = -1
    var editorMode: EditorMode = .new
    
    var service: Service?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .light
        serviceEditorTableView.layer.cornerRadius = 20
        
        serviceEditorTableView.delegate = self
        serviceEditorTableView.dataSource = self
        
        serviceEditorTableView.register(UINib(nibName: PickerSearcTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PickerSearcTableViewCell.identifier)
        
        serviceEditorTableView.register(UINib(nibName: SheetTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SheetTableViewCell.identifier)
        
        serviceEditorTableView.register(UINib(nibName: PickerTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PickerTableViewCell.identifier)
        
        serviceEditorTableView.register(UINib(nibName: RadioButtonsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RadioButtonsTableViewCell.identifier)
        
        serviceEditorTableView.register(UINib(nibName: TextViewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TextViewTableViewCell.identifier)
        
        serviceEditorTableView.register(UINib(nibName: StepperCell.identifier, bundle: nil), forCellReuseIdentifier: StepperCell.identifier)
        
        serviceEditorTableView.register(UINib(nibName: LocationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LocationTableViewCell.identifier)
        
        serviceEditorTableView.register(UINib(nibName: ButtonTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.identifier)
        
        serviceEditorTableView.register(UINib(nibName: SectionHeader.identifier, bundle: nil), forCellReuseIdentifier: SectionHeader.identifier)
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serviceEditorTableView.reloadData()
    }
    
    private func setUI() {
        
        self.overrideUserInterfaceStyle = .light
        
        switch editorMode {
        
            case .new:
                self.navigationItem.title = "New Service"
                serviceDefault = ServiceDefault()
            
            case .edit:
                self.navigationItem.title = "Edit Service"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "myLocationsSegue" {
            
            guard let destination = segue.destination as? MyLocationsViewController else {
                return
            }
            
            destination.serviceDefault = serviceDefault
        }
    }
}
extension ServiceEditorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return ServiceEditorSectionsSizes.firstSection
        case 1:
            return ServiceEditorSectionsSizes.secondSection
        case 2:
            return ServiceEditorSectionsSizes.thirdSection
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
            case 0:
                if indexPath.row == 0 {
                    
                    let cell = serviceEditorTableView.dequeueReusableCell(withIdentifier: PickerSearcTableViewCell.identifier, for: indexPath) as! PickerSearcTableViewCell
                    
                    cell.serviceDefault = serviceDefault
                    cell.setCell("Subject", servicesManager.categories.map { category in category.name })

                    return cell
                } else {
                    
                    let cell = serviceEditorTableView.dequeueReusableCell(withIdentifier: SheetTableViewCell.identifier, for: indexPath) as! SheetTableViewCell
                    
                    cell.serviceDefault = serviceDefault
                    cell.setCell("Work Type", servicesManager.serviceTypes.map {serviceType in serviceType.name })
                    
                    return cell
                }
            
            case 1:
                if indexPath.row == 0 {
                    
                    let cell = serviceEditorTableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.identifier, for: indexPath) as! PickerTableViewCell
                    
                    cell.serviceDefault = serviceDefault
                    cell.setCell("Type of Education Location", servicesManager.edLocationTypes, "locationtype")

                    return cell
                    
                } else {
                    
                    let cell = serviceEditorTableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
                    
                    if let index = locationsManager.id2index(serviceDefault?.addressid ?? -1) {
                        
                         let locationDefault = locationsManager.locationsDefault[index]
                        
                        cell.setCell("Location Point", locationDefault)
                        cell.delegate = self
                        return cell
                    }
                    
                    cell.setCell("Location Point", LocationDefault(0, 0))
                    cell.delegate = self
                    return cell
                }
            
            case 2:
                if indexPath.row == 0 {
                    
                    let cell = serviceEditorTableView.dequeueReusableCell(withIdentifier: RadioButtonsTableViewCell.identifier, for: indexPath) as! RadioButtonsTableViewCell

                    cell.serviceDefault = serviceDefault
                    cell.setCell("Student/Tutor", [("T", "Tutor"), ("S", "Student")], ("role", ""))

                    return cell
                    
                } else if indexPath.row == 1{
                    
                    let cell = serviceEditorTableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
                    
                    cell.serviceDefault = serviceDefault
                    cell.gestureDelegate = self
                    cell.setCell("Service Description", ("description", ""))

                    return cell
                    
                } else if indexPath.row == 2{
                    
                    let cell = serviceEditorTableView.dequeueReusableCell(withIdentifier: StepperCell.identifier, for: indexPath) as! StepperCell
                    
                    cell.serviceDefault = serviceDefault
                    cell.setCell("Service Price")
                    return cell
                } else {
                    
                    let cell = serviceEditorTableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
                    
                    cell.delegate = self
                    return cell
                }
                
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = serviceEditorTableView.dequeueReusableCell(withIdentifier: SectionHeader.identifier) as! SectionHeader
        
        var sectionName = ""
        
        if section == 0 {
            
            sectionName = "Subject Area"
        }
        else if section == 1 {
            
            sectionName = "Location"
        }
        else {
            
            sectionName = "General Information"
        }
        
        headerView.setHeader(sectionName)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
extension ServiceEditorViewController: SegueDelegate, GestureDelegate {

    func perform(segue identifier: String, data: [Any]?, sender: Any?) {
        
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    func addGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        
        serviceEditorTableView.addGestureRecognizer(recognizer)
    }
}
extension ServiceEditorViewController: ActionDelegate {
    
    func actionHandler() {
        if editorMode == .new {
            guard let serviceDefault = serviceDefault else{
                return
            }
            servicesManager.addService(serviceDefault, completition: {
                
                DispatchQueue.main.async {[unowned self] in
                    navigationController?.popViewController(animated: true)
                }
                
            })
        } else {
            guard let serviceDefault = serviceDefault else{
                return
            }
            
            servicesManager.replaceService(serviceDefault, with: index, completition: {
                
                DispatchQueue.main.async {[unowned self] in
                    navigationController?.popViewController(animated: true)
                }
                
            })
        }
    }
}
