//
//  ProfileEditorViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 17.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class ProfileEditorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    

    func setUI() {
        
        self.overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.isHidden = false
    }

}
