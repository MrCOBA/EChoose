//
//  MessagesViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 25.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

struct MessageStruct {
    
    var text: String
    var isIncoming: Bool
    var time: Date
}

class MessagesViewController: UIViewController {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var opponentBackgroundView: UIView!
    @IBOutlet weak var inputMessageBackgroundView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentFullnameLabel: UILabel!
    @IBOutlet weak var opponentCityLabel: UILabel!
    
    var dialog: DialogStruct!
    var notificationCenter: NotificationCenter!
    var originCenter: CGPoint!
    var deltaY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        inputTextField.delegate = self
        
        messagesTableView.register(UINib(nibName: MessageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MessageTableViewCell.identifier)
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        opponentFullnameLabel.text = dialog.opponentFullname
        opponentImageView.image = dialog.opponentImage
        opponentCityLabel.text = dialog.opponentCity
        
        notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        notificationCenter.removeObserver(self)
    }
    //MARK: - Setting up UI
    func setDialog(_ dialog: DialogStruct) {
        
        self.dialog = dialog
    }
    
    func setUI(){
        
        self.overrideUserInterfaceStyle = .light
        
        messagesTableView.layer.cornerRadius = 20
        messagesTableView.separatorStyle = .none
        messagesTableView.rowHeight = UITableView.automaticDimension
        
        opponentBackgroundView.backgroundColor = #colorLiteral(red: 0, green: 0.4156862745, blue: 0.2078431373, alpha: 1)
        opponentBackgroundView.layer.cornerRadius = 10
        opponentBackgroundView.layer.shadowColor = UIColor.black.cgColor
        opponentBackgroundView.layer.shadowOpacity = 0.5
        opponentBackgroundView.layer.shadowOffset = .zero
        opponentBackgroundView.layer.shadowRadius = 10
    }
    
    @objc
    func keyboardDidShow(notification: Notification) {
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let tableViewY = messagesTableView.frame.origin.y + messagesTableView.frame.height
        let keyboardY = keyboardSize.origin.y
        
        deltaY = abs(keyboardY - tableViewY) + 8
        originCenter = inputMessageBackgroundView.center
        
        UIView.animate(withDuration: 0.5, animations: {
            self.inputMessageBackgroundView.center = CGPoint(x: self.originCenter.x, y: self.originCenter.y - self.deltaY!)
            self.bottomConstraint.constant = self.bottomConstraint.constant + self.deltaY!
        })
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        let message = MessageStruct(text: inputTextField.text!, isIncoming: false, time: Date())
        dialog.messages.append(message)
        messagesTableView.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
            self.inputMessageBackgroundView.center = self.originCenter
            self.bottomConstraint.constant = 8
        })
        inputTextField.resignFirstResponder()
        inputTextField.text = ""
        
    }
    
}
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialog.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as! MessageTableViewCell
        
        cell.setCell(dialog.messages[indexPath.row])
        
        return cell
    }
}
extension MessagesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.inputMessageBackgroundView.center = self.originCenter
            self.bottomConstraint.constant = 8
        })
        inputTextField.resignFirstResponder()
        return true
    }
}
