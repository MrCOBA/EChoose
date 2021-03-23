//
//  FilterEditorViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 23.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class FilterEditorViewController: UIViewController {

    @IBOutlet weak var firstRadioButton: CustomButton!
    @IBOutlet weak var secondRadioButton: CustomButton!
    @IBOutlet weak var firstButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var minPriceSlider: UISlider!
    @IBOutlet weak var maxPriceSlider: UISlider!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var deletePriceFilters: UIButton!
    @IBOutlet weak var deleteDistanceFilters: UIButton!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    private var checkData = [("T", "Tutor"), ("S", "Student")]
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
    var filter: Filter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chosenType = filter?.findTutor ?? false ? AccountType.firstType : AccountType.secondType
        minPriceSlider.setValue(Float(filter?.minPrice ?? 0), animated: true)
        maxPriceSlider.setValue(Float(filter?.maxPrice ?? 0), animated: true)
        distanceSlider.setValue(Float(filter?.distance ?? 0), animated: true)
    }
    
    @IBAction func blockPrice(_ sender: Any) {
        
        if minPriceSlider.isEnabled {
            
            minPriceSlider.isEnabled = false
            maxPriceSlider.isEnabled = false
            
            
        } else {
            
            minPriceSlider.isEnabled = true
            maxPriceSlider.isEnabled = true
        }
    }
    
    @IBAction func blockDistance(_ sender: Any) {
        
        if distanceSlider.isEnabled {
            distanceSlider.isEnabled = false
            
        } else {
            distanceSlider.isEnabled = true
        }
    }
    
    
    @IBAction func minPriceChanged(_ sender: Any) {
        
        if minPriceSlider.value > maxPriceSlider.value {
            
            minPriceSlider.setValue(maxPriceSlider.value, animated: true)
        }
        minPriceLabel.text = "\(minPriceSlider.value)₽"
        filter?.minPrice = Int(minPriceSlider.value)
    }
    
    @IBAction func maxPriceChanged(_ sender: Any) {
        
        if minPriceSlider.value > maxPriceSlider.value {
            
            maxPriceSlider.setValue(minPriceSlider.value, animated: true)
        }
        maxPriceLabel.text = "\(maxPriceSlider.value)₽"
        filter?.maxPrice = Int(maxPriceSlider.value)
    }
    
    @IBAction func distanceChanged(_ sender: Any) {
        
        
    }
    
    @IBAction func confirmChanges(_ sender: Any) {
        
        if minPriceSlider.isEnabled {
            
            filter?.minPrice = Int(minPriceSlider.value)
            filter?.maxPrice = Int(maxPriceSlider.value)
            
        } else {
            
            filter?.minPrice = 1
            filter?.maxPrice = 10000
        }
        
        if distanceSlider.isEnabled {
            
            filter?.distance = Int(distanceSlider.value)
            
        } else {
            
            filter?.distance = 10000
        }
        
        if chosenType == .firstType {
            filter?.findTutor = true
        } else {
            filter?.findTutor = false
        }
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
            self.view.layoutIfNeeded()
        })
    }
}
