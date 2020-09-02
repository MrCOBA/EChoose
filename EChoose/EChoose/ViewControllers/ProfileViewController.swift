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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        setUI()
    }
    
    func setUI() {
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = #colorLiteral(red: 0.6349999905, green: 0.8550000191, blue: 0.5920000076, alpha: 1)
    }
    
    func loadData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        var saved: [User] = []
        
        do{
            try saved = context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        user = saved[0]
        
        userImageView.image = UIImage(data: user.image!)
    }
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = infoTableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
        
        return cell
    }
    
    
    
}
