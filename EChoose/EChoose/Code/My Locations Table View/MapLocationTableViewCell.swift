//
//  MapLocationTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 03.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit
import MapKit

class MapLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var mapLocationBackView: CustomView!
    @IBOutlet weak var mapLocationLabel: UILabel!
    @IBOutlet weak var mapLocationNameLabel: UILabel!
    @IBOutlet weak var setLocationButton: UIButton!
    
    static let identifier = "MapLocationTableViewCell"
    
    var delegate: SegueDelegate?
    private var location: LocationDefault? {
        
        didSet {
            mapLocationLabel.text = location?.toString()
            mapLocationNameLabel.text = location?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(_ location: LocationDefault) {
        
        self.location = location
    }
    
    @IBAction func editLocation(_ sender: Any) {
        
        delegate?.perform(segue: "locationEditorSegue", data: [(EditorMode.edit, location)], sender: nil)
    }
    
}
