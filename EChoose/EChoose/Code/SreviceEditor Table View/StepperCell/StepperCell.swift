//
//  StepperCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 01.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

protocol AlertDelegate {
    
    func present(alert: UIAlertController)
}

class StepperCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceStepper: UIStepper!
    
    var serviceManager: ServicesManager = ServicesManager.shared
    var serviceDefault: ServiceDefault?
    
    var price: Int = 0 {
        didSet {
            self.priceLabel.text = "Cost: \(price)₽"
            self.priceStepper.value = Double(price)
            if let serviceDefault = serviceDefault {
                
                serviceDefault.price = price
            }
        }
    }
    var delegate: AlertDelegate?
    
    static let identifier = "StepperCell"
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    private var cellName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        setUI()
    }
    
    func setCell(_ cellName: String) {
        
        self.cellName = cellName
        cellNameLabel.text = cellName
        
        if let serviceDefault = serviceDefault {
            price = serviceDefault.price > 0 ? serviceDefault.price : 0
        }
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
    }
    
    @IBAction func costChanged(_ sender: Any) {
        
        generator.prepare()
        generator.impactOccurred()
        price = Int(priceStepper.value)
    }
    
    @objc
    private func touchCostLabelHandler(_ recognizer: UITapGestureRecognizer) {
        
        let touchPoint = recognizer.location(in: backgroundView)
        
        if self.priceLabel.frame.contains(touchPoint) {
            let alert = UIAlertController(title: "Price of your service", message: nil, preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { textfield in
                textfield.placeholder = "Input price here..."
                textfield.keyboardType = .numberPad
                })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                if let price = Int((alert.textFields?.first?.text)!) {
                    self.price = (price / 100) * 100
                }
            }))
            
            delegate?.present(alert: alert)
        }
    }
}
