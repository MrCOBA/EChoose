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
    @IBOutlet weak var opponentImageView: CustomImageView!
    @IBOutlet weak var opponentFullnameLabel: UILabel!
    @IBOutlet weak var opponentMetaInfoLabel: UILabel!
    
    var chatController: ChatController = ChatController.shared
    var dialog: DialogDefault?
    
    var notificationCenter: NotificationCenter!
    var originCenter: CGPoint!
    var deltaY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        inputTextField.delegate = self
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        opponentBackgroundView.addGestureRecognizer(recognizer)
        
        messagesTableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.identifier)
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        opponentFullnameLabel.text = "\(dialog?.userDefault?.lastName ?? "") \(dialog?.userDefault?.firstName ?? "")"
        opponentImageView.image = dialog?.userDefault?.image ?? UIImage(named: "noimage")
        opponentMetaInfoLabel.text = "\(dialog?.userDefault?.isMale ?? true ? "Male" : "Female"), \(dialog?.userDefault?.age ?? 0) y.o."
        
        if let index = chatController.id2index(dialog?.id ?? -1) {
            subscribe(forNotification: Notification.Name("dataUpdated"))
            subscribe(forNotification: Notification.Name("newMessages"))
            chatController.initMessages(from: index)
        }
        
        messagesTableView.refreshControl = UIRefreshControl()
        messagesTableView.refreshControl?.addTarget(self, action: #selector(refreshControlHandler), for: .valueChanged)
        
        notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardHandler(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardHandler(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribe(fromNotification: Notification.Name("newMessages"))
        unsubscribe(fromNotification: Notification.Name("dataUpdated"))
        chatController.deinitCheckMessages()
        notificationCenter.removeObserver(self)
    }
    //MARK: - Setting up UI
    func setDialog(_ dialog: DialogDefault?) {
        
        self.dialog = dialog
    }
    
    func setUI(){
        
        self.overrideUserInterfaceStyle = .light
        
        messagesTableView.layer.cornerRadius = 20
        messagesTableView.separatorStyle = .none
        messagesTableView.rowHeight = UITableView.automaticDimension
        
        opponentBackgroundView.layer.cornerRadius = 20
    }
    
    func subscribe(forNotification name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_:)), name: name, object: nil)
    }
    
    func unsubscribe(fromNotification name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {[unowned self] in
            if dialog?.messages.count ?? 0 > 0 {
                let indexPath = IndexPath(row: (dialog?.messages.count ?? 0) - 1, section: 0)
                self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fullInfoSegue" {
            
            if let destination = segue.destination as? FullInfoViewController {
                
                destination.user = dialog?.userDefault
                destination.chatEnabled = false
            }
            
        }
    }
    
    @objc
    func tapHandler(_ recognizer: UIGestureRecognizer) {
        
        performSegue(withIdentifier: "fullInfoSegue", sender: nil)
    }
    
    @objc
    func notificationHandler(_ notification: Notification) {
        
        if notification.name.rawValue == "dataUpdated" {
            DispatchQueue.main.async {[unowned self] in
                messagesTableView.refreshControl?.endRefreshing()
                messagesTableView.reloadData()
            }
        } else if notification.name.rawValue == "newMessages" {
            
            DispatchQueue.main.async {[unowned self] in
                messagesTableView.reloadData()
            }
        }
    }
    
    @objc
    func refreshControlHandler() {
        
        if let index = chatController.id2index(dialog?.id ?? -1) {
            chatController.updateMessages(from: index)
        }
    }
    
    @objc
    func keyboardHandler(notification: Notification) {
        
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let tabBarFrame = tabBarController?.tabBar.frame
        
        let deltaHeight = keyboardFrame.height - tabBarFrame!.height
        
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        self.bottomConstraint.constant = isKeyboardShowing ? deltaHeight: 8
        
        UIView.animate(withDuration: 0, animations: {[unowned self] in
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        })
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if inputTextField.text! != "" {
            
            if let index = chatController.id2index(dialog?.id ?? -1) {
                chatController.sendMessage(with: inputTextField.text!, to: index)
                self.scrollToBottom()
            }
            
            inputTextField.resignFirstResponder()
            inputTextField.text = ""
        }
    }
    
}
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialog?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: ChatMessageCell.identifier, for: indexPath) as! ChatMessageCell
        cell.chatMessage = dialog?.messages[indexPath.row]
        return cell
    }
}
extension MessagesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        inputTextField.resignFirstResponder()
        return true
    }
}
