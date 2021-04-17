//
//  DialogsViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 01.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

struct DialogStruct {
    
    var messages: [MessageStruct]
    var opponentFullname: String
    var opponentCity: String
    var opponentImage: UIImage
}

class DialogsViewController: UIViewController {
    
    @IBOutlet weak var dialogsTableView: UITableView!
    
    private var selectedDialog: Int = 0
    var chatController: ChatController = ChatController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogsTableView.delegate = self
        dialogsTableView.dataSource = self

        dialogsTableView.separatorStyle = .none
        dialogsTableView.layer.cornerRadius = 20
        dialogsTableView.register(UINib(nibName: DialogTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DialogTableViewCell.identifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        subscribe(forNotification: Notification.Name("dataUpdated"))
        chatController.initDialogs()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribe(fromNotification: Notification.Name("dataUpdated"))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MessagesViewController {
            
            if selectedDialog < chatController.dialogs.count {
                destination.setDialog(chatController.dialogs[selectedDialog])
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
        
        if notification.name.rawValue == "dataUpdated" {
            DispatchQueue.main.async {[unowned self] in
                dialogsTableView.reloadData()
            }
        }
    }
}
extension DialogsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatController.dialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dialogsTableView.dequeueReusableCell(withIdentifier: DialogTableViewCell.identifier, for: indexPath) as! DialogTableViewCell
        
        cell.backgroundView = UIView()
        cell.backgroundColor = .clear
        
        cell.setCell(chatController.dialogs[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedDialog = indexPath.row
        performSegue(withIdentifier: "selectDialogSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            
            chatController.updateDialogs()
        }
    }
}
