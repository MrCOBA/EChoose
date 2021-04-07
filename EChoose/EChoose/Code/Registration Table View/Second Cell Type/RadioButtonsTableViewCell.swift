//
//  RadioButtonsTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 23.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

struct TypeSettings {
    
    var constraintConstant: CGFloat
    var backgroundColor: UIColor?
    var titleColor: UIColor?
    var title: String
}

enum AccountType: Int {
    case undefined = 0
    case firstType
    case secondType
}

class RadioButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var firstRadioButton: CustomButton!
    @IBOutlet weak var secondRadioButton: CustomButton!
    
    @IBOutlet weak var firstButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondButtonConstraint: NSLayoutConstraint!
    
    static let identifier = "RadioButtonsTableViewCell"
    private var cellName: String!
    var serviceManager: ServicesManager = ServicesManager.shared
    var serviceDefault: ServiceDefault?
    var delegate: TransferDelegate?
    var chosenType: AccountType = .undefined {
        
        didSet {
            
            if chosenType == .firstType {
                
                changeButton(firstTypeSettings: TypeSettings(
                                constraintConstant: 35,
                                backgroundColor: UIColor(named: "SecondColorGradient")!,
                                titleColor: UIColor(named: "MainColor"),
                                title: "\(checkData[0].0)"),
                             
                             secondTypeSettings: TypeSettings(
                                constraintConstant: 80,
                                backgroundColor: UIColor(named: "MainColor"),
                                titleColor: UIColor(named: "SecondColorGradient"),
                                title: "\(checkData[1].1)"))
                
                if let serviceDefault = serviceDefault{
                    serviceDefault.isTutor = true
                }
                delegate?.transferData(for: key, with: "True")
                
            } else if chosenType == .secondType {
                
                changeButton(firstTypeSettings: TypeSettings(
                                constraintConstant: 80,
                                backgroundColor: UIColor(named: "MainColor"),
                                titleColor: UIColor(named: "SecondColorGradient"),
                                title: "\(checkData[0].1)"),
                             
                             secondTypeSettings: TypeSettings(
                                    constraintConstant: 35,
                                    backgroundColor: UIColor(named: "SecondColorGradient")!,
                                    titleColor: UIColor(named: "MainColor"),
                                    title: "\(checkData[1].0)"))
                
                if let serviceDefault = serviceDefault{
                    serviceDefault.isTutor = false
                }
                delegate?.transferData(for: key, with: "False")
                
            } else {
                
                changeButton(firstTypeSettings: TypeSettings(
                                constraintConstant: 80,
                                backgroundColor: UIColor(named: "MainColor"),
                                titleColor: UIColor(named: "SecondColorGradient"),
                                title: "\(checkData[0].1)"),
                             
                             secondTypeSettings: TypeSettings(
                                    constraintConstant: 80,
                                    backgroundColor: UIColor(named: "MainColor")!,
                                    titleColor: UIColor(named: "SecondColorGradient"),
                                    title: "\(checkData[1].1)"))
            }
        }
    }
    private var key: String = ""
    private var checkData: [(Character, String)] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setCell(_ cellName: String, _ checkData: [(Character, String)], _ pair: (String, String)) {
        
        self.checkData = checkData
        self.cellName = cellName
        self.key = pair.0
        
        if let serviceDefault = serviceDefault {
            
            if serviceDefault.isTutor {
                chosenType = .firstType
            } else {
                chosenType = .secondType
            }
        } else if pair.1 != ""{
            
            if pair.1 == "False" {
                
                chosenType = .secondType
            } else {
                
                chosenType = .firstType
            }
            
        } else {
            
            chosenType = .undefined
        }
        
        cellNameLabel.text = cellName
    }
    
    private func setUI() {
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
        
        firstRadioButton.layer.cornerRadius = firstRadioButton.frame.height / 2
        secondRadioButton.layer.cornerRadius = secondRadioButton.frame.height / 2
        
        firstButtonConstraint.constant = 80
        secondButtonConstraint.constant = 80
    }
    
    @IBAction func firstButtonPressed(_ sender: Any) {
        
        chosenType = .firstType
    }
    
    @IBAction func secondButtonPressed(_ sender: Any) {
        
        chosenType = .secondType
    }
    
    func changeButton(firstTypeSettings: TypeSettings, secondTypeSettings: TypeSettings) {
        
        UIView.animate(withDuration: 0.5, animations: {[unowned self] in
            
            firstButtonConstraint.constant = firstTypeSettings.constraintConstant
            firstRadioButton.backgroundColor = firstTypeSettings.backgroundColor
            firstRadioButton.setTitleColor(firstTypeSettings.titleColor, for: .normal)
            firstRadioButton.setTitle(firstTypeSettings.title, for: .normal)
            
            secondButtonConstraint.constant = secondTypeSettings.constraintConstant
            secondRadioButton.backgroundColor = secondTypeSettings.backgroundColor
            secondRadioButton.setTitleColor(secondTypeSettings.titleColor, for: .normal)
            secondRadioButton.setTitle(secondTypeSettings.title, for: .normal)
            layoutIfNeeded()
        })
    }
}
