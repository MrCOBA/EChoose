//
//  SettingsViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 25.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit
import MapKit

class SettingsViewController: UIViewController {

    let loadingVC = LoadingViewController()
    var globalManager: GlobalManager = GlobalManager.shared
    var locationsManager: LocationsManager = LocationsManager.shared
    private var locationsData: [LocationDefault] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    

    //MARK: - Setting up UI
    func setUI(){
        
        self.overrideUserInterfaceStyle = .light
        self.navigationItem.backBarButtonItem = nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mylocationsScreenSegue" {
            
            guard let destination = segue.destination as? MyLocationsViewController else {
                return
            }
            
            destination.data = locationsData
        }
        
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
    
    @IBAction func signOut(_ sender: Any) {
        
        globalManager.quit()
        globalManager.deleteAllData("Profile")
        globalManager.deleteAllData("Service")
        globalManager.deleteAllData("Location")
        globalManager.deleteAllData("Dialog")
        globalManager.deinitRefresh()
        performSegue(withIdentifier: "loginScreenSegue", sender: self)
    }
    
    @IBAction func editProfile(_ sender: Any) {
        
        performSegue(withIdentifier: "profileEditorSegue", sender: nil)
    }
    
    @IBAction func mylocations(_ sender: Any) {
        
        displayContentController(content: loadingVC)
        
        locationsManager.loadData(completition: {
            
            DispatchQueue.main.async {[unowned self] in
                hideContentController(content: loadingVC)
                performSegue(withIdentifier: "mylocationsScreenSegue", sender: nil)
            }
        })
    }
}
