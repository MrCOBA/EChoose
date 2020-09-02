//
//  RadioButtonsTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 23.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

enum AccountType: Int {
    case undefined = 0, teacher, student
}

class RadioButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var teacherRadioButton: UIButton!
    @IBOutlet weak var studentRadioButton: UIButton!
    
    @IBOutlet weak var teacherButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var studentButtonConstraint: NSLayoutConstraint!
    
    static let identifier = "RadioButtonsTableViewCell"
    private var cellName: String!
    var chosenType: AccountType = .undefined
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setCell(_ cellName: String) {
        
        self.cellName = cellName
        cellNameLabel.text = cellName
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
        
        teacherRadioButton.layer.cornerRadius = teacherRadioButton.frame.height / 2
        studentRadioButton.layer.cornerRadius = studentRadioButton.frame.height / 2
        
        teacherButtonConstraint.constant = 80
        studentButtonConstraint.constant = 80
    }
    
    @IBAction func teacherButtonPressed(_ sender: Any) {
        
        changeButtonAnimation(teacherRadioButton)
    }
    
    @IBAction func studentButtonPressed(_ sender: Any) {
        
        changeButtonAnimation(studentRadioButton)
    }
    
    
    private func changeButtonAnimation(_ sender: UIButton!) {
        
        if sender == teacherRadioButton {
            
            switch chosenType {
                
            case .undefined:
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.teacherButtonConstraint.constant = 35
                    self.teacherRadioButton.setTitle("T", for: .normal)
                    self.layoutIfNeeded()
                    self.chosenType = .teacher
                })
            
            case .student:
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.teacherButtonConstraint.constant = 35
                    self.teacherRadioButton.setTitle("T", for: .normal)
                    self.studentButtonConstraint.constant = 80
                    self.studentRadioButton.setTitle("Student", for: .normal)
                    self.layoutIfNeeded()
                    self.chosenType = .teacher
                })
                
            case .teacher:
                break
            }
        }
        else {
            
            switch chosenType {
                
            case .undefined:
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.studentButtonConstraint.constant = 35
                    self.studentRadioButton.setTitle("S", for: .normal)
                    self.layoutIfNeeded()
                    self.chosenType = .student
                })
                
            case .teacher:
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.studentButtonConstraint.constant = 35
                    self.studentRadioButton.setTitle("S", for: .normal)
                    self.teacherButtonConstraint.constant = 80
                    self.teacherRadioButton.setTitle("Teacher", for: .normal)
                    self.layoutIfNeeded()
                    self.chosenType = .student
                })
                
            case .student:
                break
            }
        }
    }
}
