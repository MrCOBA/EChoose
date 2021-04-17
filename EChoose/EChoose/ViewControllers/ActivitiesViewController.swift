//
//  ActivitiesViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 25.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController {

    @IBOutlet weak var noActivityLabel: UILabel!
    @IBOutlet weak var noActivityImageView: UIImageView!
    @IBOutlet weak var noActivityView: CustomView!
    
    @IBOutlet weak var activitiesTableView: UITableView!
    @IBOutlet weak var activitiesControl: UISegmentedControl!
    
    private var transferData: (Offer?, UserDefault?)
    
    var chatController: ChatController = ChatController.shared
    var activitiesManager: ActivitiesManager = ActivitiesManager.shared
    var globalManager: GlobalManager = GlobalManager.shared
    var offersManager: OffersManager = OffersManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        
        activitiesTableView.register(UINib(nibName: ActivityTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ActivityTableViewCell.identifier)
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribe(forNotification: Notification.Name("dataUpdated"))
        subscribe(forNotification: Notification.Name("dialogLoaded"))
        
        if activitiesControl.selectedSegmentIndex == 0 {
            activitiesManager[.match]?.clear()
            activitiesManager[.match]?.loadActivity()
        } else if activitiesControl.selectedSegmentIndex == 1 {
            activitiesManager[.archive]?.clear()
            activitiesManager[.archive]?.loadActivity()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribe(fromNotification: Notification.Name("dataUpdated"))
        unsubscribe(fromNotification: Notification.Name("dialogLoaded"))
    }
    
    //MARK: - Setting up UI
    func setUI(){
        
        noActivityView.isHidden = true
        
        self.overrideUserInterfaceStyle = .light
        activitiesTableView.layer.cornerRadius = 20
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fullInfoSegue" {
            
            guard let destination = segue.destination as? FullInfoViewController else {
                return
            }
            
            destination.offer = transferData.0
            destination.user = transferData.1
            
            destination.chatEnabled = activitiesControl.selectedSegmentIndex == 0
        } else if segue.identifier == "openDialogSegue" {
            
            guard let destination = segue.destination as? MessagesViewController else {
                return
            }
            
            destination.dialog = chatController.dialogs[0]
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
        
        DispatchQueue.main.async {[unowned self] in
            if notification.name.rawValue == "dataUpdated" {
                
                updateTableView()
                
            } else if notification.name.rawValue == "dialogLoaded" {
                
                DispatchQueue.main.async {[unowned self] in
                    performSegue(withIdentifier: "openDialogSegue", sender: nil)
                }
            }
        }
    }
    
    func updateTableView() {
        
        activitiesTableView.reloadData()
        
        if activitiesControl.selectedSegmentIndex == 0 {
            
            if activitiesManager[.match]?.size() ?? 0 == 0 {
                
                noActivityLabel.text = "No Matches yet!"
                noActivityImageView.image = UIImage(named: "nohandshake")
                noActivityView.isHidden = false
            } else {
                noActivityView.isHidden = true
            }
            
        } else if activitiesControl.selectedSegmentIndex == 1 {
            
            if activitiesManager[.archive]?.size() ?? 0 == 0 {
                
                noActivityLabel.text = "No Archives!"
                noActivityImageView.image = UIImage(named: "noarchived")
                noActivityView.isHidden = false
            } else {
                noActivityView.isHidden = true
            }
        }
    }
    
    @IBAction func activityChanged(_ sender: Any) {
        
        if activitiesControl.selectedSegmentIndex == 0 {
            noActivityView.isHidden = true
            activitiesManager[.match]?.clear()
            activitiesManager[.match]?.loadActivity()
        } else if activitiesControl.selectedSegmentIndex == 1 {
            noActivityView.isHidden = true
            activitiesManager[.archive]?.clear()
            activitiesManager[.archive]?.loadActivity()
        }
    }
}
extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if activitiesControl.selectedSegmentIndex == 0 {
            
            return activitiesManager[.match]?.size() ?? 0
            
        } else if activitiesControl.selectedSegmentIndex == 1 {
            
            return activitiesManager[.archive]?.size() ?? 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = activitiesTableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath) as! ActivityTableViewCell
        
        cell.backgroundView = UIView()
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = .clear
        
        if activitiesControl.selectedSegmentIndex == 0 {
            
            cell.setCell(activitiesManager[.match]?.get(indexPath.row), activitiesManager[.match]?.get(indexPath.row))
              
            cell.firstActionButton.setImage(UIImage(named: "dialogimage"), for: .normal)
            cell.secondActionButton.setImage(UIImage(named: "deleteimage"), for: .normal)
            
            cell.firstAction = {[unowned self] (offer, user) in
                
                if let id = user?.id {
                    chatController.startDialog(with: id)
                }
            }
            
            cell.secondAction = {[unowned self] (offer, user) in
                
                let alertGenerator = AlertGenerator(firstAction: {(action) in
                    
                    guard let url = URL(string: "\(globalManager.apiURL)/offers/\(offer?.id ?? -1)/react/") else {
                        return
                    }
                    
                    if let jsonData = globalManager.reactJSON(from: offersManager.offersQueue.filter, status: "Archive") {
                        
                        globalManager.POST(url: url, data: jsonData, withSerializer: nil, isAuthorized: true, completition: {
                            DispatchQueue.main.async {
                                
                                activitiesManager[.match]?.clear()
                                activitiesManager[.match]?.loadActivity()
                            }
                        })
                    }
                    
                        
                }, secondAction: {[unowned self] (action) in
                    
                    guard let url = URL(string: "\(globalManager.apiURL)/offers/\(offer?.id ?? -1)/react/") else {
                        return
                    }
                    
                    if let jsonData = globalManager.reactJSON(from: offersManager.offersQueue.filter, status: "Dislike") {
                        
                        globalManager.POST(url: url, data: jsonData, withSerializer: nil, isAuthorized: true, completition: {
                            DispatchQueue.main.async {
                                
                                activitiesManager[.match]?.clear()
                                activitiesManager[.match]?.loadActivity()
                            }
                        })
                    }
                })
                
                if let alertController = alertGenerator.getAlert()[AlertType.matchActions] {
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            
        } else if activitiesControl.selectedSegmentIndex == 1 {
            
            cell.setCell(activitiesManager[.archive]?.get(indexPath.row), activitiesManager[.archive]?.get(indexPath.row))
            
            cell.firstActionButton.setImage(UIImage(named: "likeImage"), for: .normal)
            cell.secondActionButton.setImage(UIImage(named: "dislikeImage"), for: .normal)
            
            cell.firstAction = {[unowned self] (offer, user) in
                
                guard let url = URL(string: "\(globalManager.apiURL)/offers/\(offer?.id ?? -1)/react/") else {
                    return
                }
                
                if let jsonData = globalManager.reactJSON(from: offersManager.offersQueue.filter, status: "Like") {
                    
                    globalManager.POST(url: url, data: jsonData, withSerializer: nil, isAuthorized: true, completition: {
                        DispatchQueue.main.async {
                            
                            activitiesManager[.archive]?.clear()
                            activitiesManager[.archive]?.loadActivity()
                        }
                    })
                }
            }
            
            cell.secondAction = {[unowned self] (offer, user) in
                
                guard let url = URL(string: "\(globalManager.apiURL)/offers/\(offer?.id ?? -1)/react/") else {
                    return
                }
                
                if let jsonData = globalManager.reactJSON(from: offersManager.offersQueue.filter, status: "Dislike") {
                    
                    globalManager.POST(url: url, data: jsonData, withSerializer: nil, isAuthorized: true, completition: {
                        DispatchQueue.main.async {
                            
                            activitiesManager[.archive]?.clear()
                            activitiesManager[.archive]?.loadActivity()
                        }
                    })
                }
            }
            
            
        }
        
        cell.delegate = self
        
        return cell
    }
}
extension ActivitiesViewController: SegueDelegate {
    
    func perform(segue identifier: String, data: [Any]?, sender: Any?) {
        
        if let transferData = data?[0] as? (Offer?, UserDefault?) {
            
            self.transferData = transferData
            performSegue(withIdentifier: identifier, sender: nil)
        }
    }
    
}
