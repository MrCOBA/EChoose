//
//  LocationTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 03.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

protocol SegueDelegate {
    
    func perform(segue identifier: String, data: [Any]?, sender: Any?)
}

class LocationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var locationBackView: CustomView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    
    static let identifier = "LocationTableViewCell"
    var locationsManager: LocationsManager = LocationsManager.shared
    var delegate: SegueDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }

    func setCell(_ name: String, _ location: LocationDefault) {
        
        cellNameLabel.text = name
        locationLabel.text = location.toString()
        locationNameLabel.text = location.name
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
        locationsManager.loadData(completition: {
            
            DispatchQueue.main.async {[unowned self] in
                delegate?.perform(segue: "myLocationsSegue", data: nil, sender: nil)
            }
        })
        
        
    }
        
}
