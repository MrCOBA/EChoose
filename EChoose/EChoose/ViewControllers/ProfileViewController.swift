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
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var rolerLabel: UILabel!
    @IBOutlet weak var infoTableView: UITableView!
    
    var user: User!
    
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
        
        loadData()
        setUI()
    }
    
    func setUI() {
        
        infoTableView.separatorStyle = .none
        infoTableView.layer.cornerRadius = 10
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = #colorLiteral(red: 0.6349999905, green: 0.8550000191, blue: 0.5920000076, alpha: 1)
        
        backgroundView.layer.cornerRadius = 5
        backgroundView.layer.borderWidth = 3
        backgroundView.layer.borderColor = #colorLiteral(red: 0.6349999905, green: 0.8550000191, blue: 0.5920000076, alpha: 1)
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = .zero
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 0.5
        
    }
    
    func loadData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do{
            try user = context.fetch(fetchRequest).first
        } catch {
            print(error.localizedDescription)
        }
        
        userImageView.image = UIImage(data: user.image!)
        fullnameLabel.text = "\(user.fullname!), \(user.age)"
        rolerLabel.text = "\(user.role!)"
    }
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
        
            cell.setCell(UIImage(named: "usernameimage")!, "Username", user.username!)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
            
            cell.setCell(UIImage(named: "cityimage")!, "City", user.city!)
            return cell
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
            
            cell.setCell(UIImage(named: "emailimage")!, "E-Mail", user.email!)
            return cell
        } else if indexPath.row == 3{
            
            let resizeableCell = tableView.dequeueReusableCell(withIdentifier: ResizeableInfoTableViewCell.identifier, for: indexPath) as! ResizeableInfoTableViewCell
            
            resizeableCell.setCell(UIImage(named: "descriptionimage")!, "Description", user.descript!)
            return resizeableCell
        } else {
            let editCell = tableView.dequeueReusableCell(withIdentifier: EditTableViewCell.identifier, for: indexPath) as! EditTableViewCell
            
            editCell.setCell(self)
            
            return editCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3 {
            return UITableView.automaticDimension
        } else {
            return 63
        }
    }
}
