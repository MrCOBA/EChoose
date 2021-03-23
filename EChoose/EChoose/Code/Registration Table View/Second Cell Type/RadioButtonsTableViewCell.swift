//
//  RadioButtonsTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 23.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

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
                
                UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                    
                    self.firstButtonConstraint.constant = 35
                    self.firstRadioButton.setTitle("\(checkData[0].0)", for: .normal)
                    self.firstRadioButton.backgroundColor = UIColor(named: "SecondColorGradient")
                    self.firstRadioButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
                    self.secondButtonConstraint.constant = 80
                    self.secondRadioButton.setTitle("\(checkData[1].1)", for: .normal)
                    self.secondRadioButton.backgroundColor = UIColor(named: "MainColor")
                    self.secondRadioButton.setTitleColor(UIColor(named: "SecondColorGradient"), for: .normal)
                    self.layoutIfNeeded()
                    if let serviceDefault = serviceDefault{
                        serviceDefault.isTutor = true
                    }
                    delegate?.transferData(for: key, with: "True")
                })
                
            } else if chosenType == .secondType {
                
                UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                    
                    self.secondButtonConstraint.constant = 35
                    self.secondRadioButton.setTitle("\(checkData[1].0)", for: .normal)
                    self.secondRadioButton.backgroundColor = UIColor(named: "SecondColorGradient")
                    self.secondRadioButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
                    self.firstButtonConstraint.constant = 80
                    self.firstRadioButton.setTitle("\(checkData[0].1)", for: .normal)
                    self.firstRadioButton.backgroundColor = UIColor(named: "MainColor")
                    self.firstRadioButton.setTitleColor(UIColor(named: "SecondColorGradient"), for: .normal)
                    self.layoutIfNeeded()
                    if let serviceDefault = serviceDefault{
                        serviceDefault.isTutor = false
                    }
                    delegate?.transferData(for: key, with: "False")
                })
            } else {
                
                UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                    
                    self.firstButtonConstraint.constant = 80
                    self.firstRadioButton.setTitle("\(checkData[0].1)", for: .normal)
                    self.firstRadioButton.backgroundColor = UIColor(named: "MainColor")
                    self.firstRadioButton.setTitleColor(UIColor(named: "SecondColorGradient"), for: .normal)
                    self.secondButtonConstraint.constant = 80
                    self.secondRadioButton.setTitle("\(checkData[1].1)", for: .normal)
                    self.secondRadioButton.backgroundColor = UIColor(named: "MainColor")
                    self.secondRadioButton.setTitleColor(UIColor(named: "SecondColorGradient"), for: .normal)
                    self.layoutIfNeeded()
                    
                })
            }
        }
    }
    private var key: String = ""
    private var checkData: [(Character, String)] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setCell(_ cellName: String, _ checkData: [(Character, String)], _ key: String) {
        
        self.checkData = checkData
        self.cellName = cellName
        self.key = key
        
        if let serviceDefault = serviceDefault {
            
            if serviceDefault.isTutor {
                chosenType = .firstType
            } else {
                chosenType = .secondType
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
    
    @IBAction func teacherButtonPressed(_ sender: Any) {
        
        chosenType = .firstType
    }
    
    @IBAction func studentButtonPressed(_ sender: Any) {
        
        chosenType = .secondType
    }
    
    
    private func changeButtonAnimation(_ sender: UIButton!) {
        
        if sender == firstRadioButton {
            
            switch chosenType {
                
                case .undefined:
                    UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                        
                        self.firstButtonConstraint.constant = 35
                        self.firstRadioButton.setTitle("\(checkData[0].0)", for: .normal)
                        self.firstRadioButton.backgroundColor = UIColor(named: "SecondColorGradient")
                        self.firstRadioButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
                        self.layoutIfNeeded()
                        self.chosenType = .firstType
                        if let serviceDefault = serviceDefault{
                            serviceDefault.isTutor = true
                        }
                        delegate?.transferData(for: key, with: "True")
                    })
                
                case .secondType:
                    UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                        
                        self.firstButtonConstraint.constant = 35
                        self.firstRadioButton.setTitle("\(checkData[0].0)", for: .normal)
                        self.firstRadioButton.backgroundColor = UIColor(named: "SecondColorGradient")
                        self.firstRadioButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
                        self.secondButtonConstraint.constant = 80
                        self.secondRadioButton.setTitle("\(checkData[1].1)", for: .normal)
                        self.secondRadioButton.backgroundColor = UIColor(named: "MainColor")
                        self.secondRadioButton.setTitleColor(UIColor(named: "SecondColorGradient"), for: .normal)
                        self.layoutIfNeeded()
                        self.chosenType = .firstType
                        if let serviceDefault = serviceDefault{
                            serviceDefault.isTutor = true
                        }
                        delegate?.transferData(for: key, with: "True")
                    })
                    
                case .firstType:
                    break
            }
        }
        else {
            
            switch chosenType {
                
                case .undefined:
                    UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                        
                        self.secondButtonConstraint.constant = 35
                        self.secondRadioButton.setTitle("\(checkData[1].0)", for: .normal)
                        self.secondRadioButton.backgroundColor = UIColor(named: "SecondColorGradient")
                        self.secondRadioButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
                        self.layoutIfNeeded()
                        self.chosenType = .secondType
                        if let serviceDefault = serviceDefault{
                            serviceDefault.isTutor = false
                        }
                        delegate?.transferData(for: key, with: "False")
                    })
                    
                case .firstType:
                    UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                        
                        self.secondButtonConstraint.constant = 35
                        self.secondRadioButton.setTitle("\(checkData[1].0)", for: .normal)
                        self.secondRadioButton.backgroundColor = UIColor(named: "SecondColorGradient")
                        self.secondRadioButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
                        self.firstButtonConstraint.constant = 80
                        self.firstRadioButton.setTitle("\(checkData[0].1)", for: .normal)
                        self.firstRadioButton.backgroundColor = UIColor(named: "MainColor")
                        self.firstRadioButton.setTitleColor(UIColor(named: "SecondColorGradient"), for: .normal)
                        self.layoutIfNeeded()
                        self.chosenType = .secondType
                        if let serviceDefault = serviceDefault{
                            serviceDefault.isTutor = false
                        }
                        delegate?.transferData(for: key, with: "False")
                    })
                    
                case .secondType:
                    break
            }
        }
    }
}
