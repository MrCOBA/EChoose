//
//  FullInfoViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 28.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class FullInfoViewController: UIViewController {

    @IBOutlet weak var fullInfoTableView: UITableView!
    
    var chatController: ChatController = ChatController.shared
    var servicesManager: ServicesManager = ServicesManager.shared
    var offer: Offer?
    var user: UserDefault?
    
    var chatEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribe(forNotification: Notification.Name("dialogLoaded"))
        
        
        fullInfoTableView.delegate = self
        fullInfoTableView.dataSource = self
        
        fullInfoTableView.register(UINib(nibName: InfoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InfoTableViewCell.identifier)
        
        fullInfoTableView.register(UINib(nibName: ResizeableInfoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ResizeableInfoTableViewCell.identifier)
        
        fullInfoTableView.register(UINib(nibName: ProfileTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
        fullInfoTableView.register(UINib(nibName: SectionHeader.identifier, bundle: nil), forCellReuseIdentifier: SectionHeader.identifier)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "openDialogSegue" {
            
            if let destination = segue.destination as? MessagesViewController{
                
                if let _ = user?.id {
                    
                    destination.dialog = chatController.dialogs[0]
                }
            }
            
        }
    }
    
    func subscribe(forNotification name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_:)), name: name, object: nil)
    }
    
    func unsubscribe(fromNotification name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    @objc
    func notificationHandler(_ notification: Notification) {
        
        if notification.name.rawValue == "dialogLoaded" {
            DispatchQueue.main.async {[unowned self] in
                performSegue(withIdentifier: "openDialogSegue", sender: nil)
            }
        }
    }
}
extension FullInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let _ = user else {
            return 0
        }
        
        guard let _ = offer else {
            return 1
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 4
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0,
           let user = user{
            
            switch indexPath.row {
            
            case 0:
                let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
                
                let image = user.image ?? UIImage(named: "noimage")!
                
                cell.setCell(image, "\(user.lastName) \(user.firstName), \(user.age)", chatEnabled)
                cell.delegate = self
                return cell
            
            case 1:
                
                let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
                
                cell.setCell(UIImage(named: "genderimage")!, "M/F", user.isMale ? "Male" : "Female")
                
                return cell
            
            case 2:
                
                let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
                
                cell.setCell(UIImage(named: "emailimage")!, "E-Mail", user.email == "" ? "No Email" : user.email)
                
                return cell
            
            case 3:
                
                let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: ResizeableInfoTableViewCell.identifier, for: indexPath) as! ResizeableInfoTableViewCell
                
                cell.setCell(UIImage(named: "descriptionimage")!, "Description", user.userDescription == "" ? "No Description" : user.userDescription)
                
                return cell
                
            default :
                return UITableViewCell()
            }
            
        } else if let offer = offer{
            
            switch indexPath.row {
            
            case 0:
                let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
                
                guard let category = servicesManager.categories.first(where: {category in return category.id == offer.categoryid}) else {
                    return cell
                }
                
                cell.setCell(UIImage(named: "categoryimage")!, "Category", category.name)
                
                return cell
                
            case 1:
                let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
                
                cell.setCell(UIImage(named: "edlocationimage")!, "Ed. Location", offer.edLocation)
                
                return cell
                
            case 2:
                let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: ResizeableInfoTableViewCell.identifier, for: indexPath) as! ResizeableInfoTableViewCell
                
                cell.setCell(UIImage(named: "addressimage")!, "Address", offer.locationDefault?.toString() ?? "No pinned Address")
                
                return cell
            
            case 3:
                let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: ResizeableInfoTableViewCell.identifier, for: indexPath) as! ResizeableInfoTableViewCell
                
                var serviceTypesStr = ""
                
                let serviceTypes = servicesManager.serviceTypes.filter({serviceType in return offer.types.contains(serviceType.id)})
                
                for (i, serviceType) in serviceTypes.enumerated() {
                    
                    serviceTypesStr += "\(i + 1). \(serviceType.name)" + (i == serviceTypes.count - 1 ? "" : "\n")
                }
                
                cell.setCell(UIImage(named: "typesimage")!, "Serv. Types", serviceTypesStr == "" ? "No Selected Service Types" : serviceTypesStr)
                
                return cell
            
            case 4:
                
                let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: ResizeableInfoTableViewCell.identifier, for: indexPath) as! ResizeableInfoTableViewCell
                
                cell.setCell(UIImage(named: "descriptionimage")!, "Description", offer.serviceDescription == "" ? "No Description" : offer.serviceDescription)
                
                return cell
                
            case 5:
                let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
                
                cell.setCell(UIImage(named: "priceimage")!, "Price", "\(offer.price)₽")
                
                return cell
            default :
                return UITableViewCell()
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = fullInfoTableView.dequeueReusableCell(withIdentifier: SectionHeader.identifier) as! SectionHeader
        
        var sectionName = ""
        
        if section == 0 {
            
            sectionName = "User Info"
        }
        else {
            
            sectionName = "Service Info"
        }
        
        headerView.setHeader(sectionName)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
extension FullInfoViewController: ActionDelegate {
    
    func actionHandler() {
        
        if let id = user?.id {
            chatController.startDialog(with: id)
        }
    }
}
