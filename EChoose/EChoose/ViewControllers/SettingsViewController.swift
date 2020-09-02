//
//  SettingsViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 25.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    

    //MARK: - Setting up UI
    func setUI(){
        
        self.overrideUserInterfaceStyle = .light
        self.navigationItem.backBarButtonItem = nil
    }

}
