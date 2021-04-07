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
    
    @IBOutlet weak var minPriceSlider: CustomSlider!
    @IBOutlet weak var maxPriceSlider: CustomSlider!
    @IBOutlet weak var distanceSlider: CustomSlider!
    @IBOutlet weak var deletePriceFilters: UIButton!
    @IBOutlet weak var deleteDistanceFilters: UIButton!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var updateClosure: (() -> Void)?
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
        
        minPriceLabel.text = "\(Int(minPriceSlider.value))₽"
        maxPriceLabel.text = "\(Int(maxPriceSlider.value))₽"
        distanceLabel.text = "\(Int(distanceSlider.value)) km"
    }
    
    @IBAction func blockPrice(_ sender: Any) {
        
        if minPriceSlider.isEnabled {
            
            minPriceSlider.isEnabled = false
            maxPriceSlider.isEnabled = false
            
            deletePriceFilters.setImage(UIImage(named: "activatedstate"), for: .normal)
            deletePriceFilters.tintColor = UIColor(named: "likeGreen")
            
        } else {
            
            minPriceSlider.isEnabled = true
            maxPriceSlider.isEnabled = true
            
            deletePriceFilters.setImage(UIImage(named: "unactivatedstate"), for: .normal)
            deletePriceFilters.tintColor = UIColor(named: "dislikeColor")
        }
    }
    
    @IBAction func blockDistance(_ sender: Any) {
        
        if distanceSlider.isEnabled {
            distanceSlider.isEnabled = false
            
            deleteDistanceFilters.setImage(UIImage(named: "activatedstate"), for: .normal)
            deleteDistanceFilters.tintColor = UIColor(named: "likeGreen")
            
        } else {
            distanceSlider.isEnabled = true
            
            deleteDistanceFilters.setImage(UIImage(named: "unactivatedstate"), for: .normal)
            deleteDistanceFilters.tintColor = UIColor(named: "dislikeColor")
        }
    }
    
    
    @IBAction func minPriceChanged(_ sender: Any) {
        
        minPriceSlider.value = Float(Int(minPriceSlider.value) / 100 * 100)
        
        if minPriceSlider.value > maxPriceSlider.value {
            
            minPriceSlider.setValue(maxPriceSlider.value, animated: true)
        }
        minPriceLabel.text = "\((Int(minPriceSlider.value) / 100) * 100 )₽"
        filter?.minPrice = (Int(minPriceSlider.value) / 100) * 100
    }
    
    @IBAction func maxPriceChanged(_ sender: Any) {
        
        maxPriceSlider.value = Float(Int(maxPriceSlider.value) / 100 * 100)
        
        if minPriceSlider.value > maxPriceSlider.value {
            
            maxPriceSlider.setValue(minPriceSlider.value, animated: true)
        }
        maxPriceLabel.text = "\((Int(maxPriceSlider.value) / 100) * 100 )₽"
        filter?.maxPrice = (Int(maxPriceSlider.value) / 100) * 100
    }
    
    @IBAction func distanceChanged(_ sender: Any) {
        
        distanceSlider.value = Float(Int(distanceSlider.value) / 100 * 100)
        
        distanceLabel.text = "\((Int(distanceSlider.value) / 100) * 100 ) km"
        filter?.distance = (Int(distanceSlider.value) / 100) * 100
    }
    
    @IBAction func confirmChanges(_ sender: Any) {
        
        if minPriceSlider.isEnabled {
            
            filter?.minPrice = Int(minPriceSlider.value)
            filter?.maxPrice = Int(maxPriceSlider.value)
            
        } else {
            
            filter?.minPrice = 100
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
        
        dismiss(animated: true, completion: nil)
        updateClosure?()
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
