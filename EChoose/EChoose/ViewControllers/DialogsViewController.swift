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
    
    var dialogs: [DialogStruct] = [DialogStruct(messages: [MessageStruct(text: "Hello, Oleg.", isIncoming: true, time: Date()), MessageStruct(text: "Hello, Sergey Mihailovich!", isIncoming: false, time: Date())], opponentFullname: "Avdoshin Sergey", opponentCity: "Moscow", opponentImage: UIImage(systemName: "person.circle.fill")!)]
    var selectedDialog: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogsTableView.delegate = self
        dialogsTableView.dataSource = self
        
        dialogsTableView.separatorStyle = .none
        dialogsTableView.layer.cornerRadius = 10
        dialogsTableView.register(UINib(nibName: DialogTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DialogTableViewCell.identifier)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! MessagesViewController
        
        destination.setDialog(dialogs[selectedDialog])
    }
}
extension DialogsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dialogsTableView.dequeueReusableCell(withIdentifier: DialogTableViewCell.identifier, for: indexPath) as! DialogTableViewCell
        
        cell.setCell(dialogs[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedDialog = indexPath.row
        performSegue(withIdentifier: "selectDialogSegue", sender: nil)
    }
    
}
