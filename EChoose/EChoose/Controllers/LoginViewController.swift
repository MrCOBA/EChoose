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
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}

