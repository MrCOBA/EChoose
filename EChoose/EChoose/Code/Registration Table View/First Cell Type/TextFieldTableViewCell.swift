//
//  TextFieldTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 23.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    static let identifier = "TextFieldTableViewCell"
    var delegate: TransferDelegate?
    private var key = ""
    private var cellName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputTextField.delegate = self
        setUI()
    }
    
    func setCell(_ cellName: String, _ isSecured: Bool, _ placholder: String, _ keyboardType: UIKeyboardType = .default, _ pair: (String, String)) {
        self.key = pair.0
        inputTextField.text = pair.1
        cellNameLabel.text = cellName
        inputTextField.isSecureTextEntry = isSecured
        inputTextField.placeholder = placholder
        inputTextField.keyboardType = keyboardType
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
    }
}
extension TextFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.transferData(for: key, with: inputTextField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        inputTextField.resignFirstResponder()
        return true
    }
}


