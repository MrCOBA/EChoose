//
//  ProfileViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 01.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var userImageView: CustomImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var infoTableView: UITableView!
    
    var globalManager: GlobalManager = GlobalManager.shared
    let loadingVC = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.register(UINib(nibName: InfoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InfoTableViewCell.identifier)
        infoTableView.register(UINib(nibName: ResizeableInfoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ResizeableInfoTableViewCell.identifier)
        infoTableView.register(UINib(nibName: EditTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: EditTableViewCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayContentController(content: loadingVC)
        guard let url = URL(string: "\(globalManager.apiURL)/profile/") else {
            return
        }
        
        globalManager.GET(url: url, data: nil, withSerializer: globalManager.profileSerializer(_:), isAuthorized: true, completition: {
            
            DispatchQueue.main.async {[unowned self] in
                if let firstname = globalManager.user?.profile?.firstname,
                   let lastname = globalManager.user?.profile?.lastname,
                   let age = globalManager.user?.profile?.age {
                    
                    fullnameLabel.text = "\(firstname) \(lastname), \(age)"
                }
                
                if let imageURL = globalManager.imageURL {
                    
                    guard let url = URL(string: "\(globalManager.apiURL)/\(imageURL)/") else {
                        return
                    }
                    
                    globalManager.downloadImage(from: url, completition: {
                        DispatchQueue.main.async {
                            if let image = globalManager.buffer as? UIImage {
                                userImageView.image = image
                            }
                            hideContentController(content: loadingVC)
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        hideContentController(content: loadingVC)
                    }
                }
            }
        })
        setUI()
    }
    
    func setUI() {
        
        infoTableView.separatorStyle = .none
        infoTableView.layer.cornerRadius = 10
        
        backgroundView.layer.cornerRadius = 5
        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = #colorLiteral(red: 0.6349999905, green: 0.8550000191, blue: 0.5920000076, alpha: 1)
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = .zero
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 0.5
        
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
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
        
            cell.setCell(UIImage(named: "usernameimage")!, "Username", globalManager.user?.username ?? "No Username")
            return cell
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
            
            cell.setCell(UIImage(named: "emailimage")!, "E-Mail", globalManager.user?.profile?.email ?? "No Email")
            return cell
        } else {
            
            let resizeableCell = tableView.dequeueReusableCell(withIdentifier: ResizeableInfoTableViewCell.identifier, for: indexPath) as! ResizeableInfoTableViewCell
            
            resizeableCell.setCell(UIImage(named: "descriptionimage")!, "Description", globalManager.user?.profile?.descript ?? "No Description")
            return resizeableCell
        }
    }
}
