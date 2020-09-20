//
//  EditTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 08.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    
    static let identifier = "EditTableViewCell"
    private var profileVC: ProfileViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI() {
        
        editButton.layer.cornerRadius = editButton.frame.height / 2
        editButton.layer.shadowColor = UIColor.black.cgColor
        editButton.layer.shadowOffset = .zero
        editButton.layer.shadowRadius = 5
        editButton.layer.shadowOpacity = 0.5
    }
    
    func setCell(_ profileVC: ProfileViewController) {
        
        self.profileVC = profileVC
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        profileVC.performSegue(withIdentifier: "profileEditorSegue", sender: nil)
    }
    
}
