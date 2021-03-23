//
//  LoginViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 17.07.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let loadingVC = LoadingViewController()
    
    private var loginTimer: Timer?
    var globalManager: GlobalManager = GlobalManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHandler))
        self.view.addGestureRecognizer(gestureRecognizer)
        setUI()
    }

    //MARK: - Setting up UI
    func setUI(){
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        self.overrideUserInterfaceStyle = .light
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2
        logoView.layer.cornerRadius = logoView.frame.width / 2
        logoView.layer.shadowColor = #colorLiteral(red: 0.960748136, green: 0.9848688245, blue: 0.4547813535, alpha: 1)
        logoView.layer.shadowOffset = .zero
        logoView.layer.shadowOpacity = 0.8
        logoView.layer.shadowRadius = 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mainScreenSegue" {
            let destination = segue.destination as! UITabBarController
            
            destination.selectedIndex = 2
            destination.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func subscribe(forNotification name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_:)), name: name, object: nil)
    }
    
    func unsubscribe(fromNotification name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    
    @objc func notificationHandler(_ notification: Notification) {
        if notification.name.rawValue == "loginSuccess" {
            
            DispatchQueue.main.async {[unowned self] in
                unsubscribe(fromNotification: Notification.Name("loginSuccess"))
                unsubscribe(fromNotification: Notification.Name("loginUnsuccess"))
                hideContentController(content: loadingVC)
                globalManager.initRefresh()
                performSegue(withIdentifier: "mainScreenSegue", sender: nil)
            }
        } else if notification.name.rawValue == "loginUnsuccess"{
            
            DispatchQueue.main.async {[unowned self] in
                hideContentController(content: loadingVC)
            }
        }
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        if username != "" && password != "" {
            
            subscribe(forNotification: Notification.Name("loginSuccess"))
            subscribe(forNotification: Notification.Name("loginUnsuccess"))
            
            displayContentController(content: loadingVC)
            
            globalManager.tokenInit(username: username, password: password)
        }
        
    }
    
    @objc
    func touchHandler(_ recognizer: UIGestureRecognizer) {
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
    }
}
