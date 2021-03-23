//
//  WorkTypeCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 01.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

protocol MultipleSelectioDelegate {
    
    func select(_ id: Int)
    func deselect(_ id: Int)
}

class MultipleSelectionCell: UITableViewCell {

    @IBOutlet weak var multipleSelectionButton: CustomButton!
    
    var delegate: MultipleSelectioDelegate?
    
    private var id: Int = -1
    private var selectionState: Bool = false {
        
        didSet {
            if selectionState {
                self.multipleSelectionButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
                self.multipleSelectionButton.backgroundColor = UIColor(named: "SecondColorGradient")
                delegate?.select(id)
            }
            else {
                self.multipleSelectionButton.setTitleColor(UIColor(named: "SecondColorGradient"), for: .normal)
                self.multipleSelectionButton.backgroundColor = UIColor(named: "MainColor")
                delegate?.deselect(id)
            }
        }
    }
    
    static let identifier: String = "MultipleSelectionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func changeState(for state: Bool) {
        
        selectionState = state
    }
    
    func setUpCell(_ name: String, _ id: Int) {
        multipleSelectionButton.setTitle(name, for: .normal)
        self.id = id
    }
    
    @IBAction func selectAction(_ sender: Any) {
        
        selectionState = !selectionState
    }
}
