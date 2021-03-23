//
//  ImageTableViewCell.swift
//  EChoose
//
//  Created by Oparin Oleg on 08.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

protocol ImageEditorDelegate {
    
    func presentPicker()
}

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    static let identifier = "ImageTableViewCell"
    var delegate: ImageEditorDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    private func setUI() {
        
        cellNameView.layer.cornerRadius = 10
        
        cellNameView.layer.shadowColor = UIColor.black.cgColor
        cellNameView.layer.shadowOffset = .zero
        cellNameView.layer.shadowOpacity = 0.5
        cellNameView.layer.shadowRadius = 5
    }
    
    func setCell(_ name: String) {
        
        cellNameLabel.text = name
    }
    
    
    @IBAction func clearImage(_ sender: Any) {
        
        profileImageView.image = UIImage(named: "addimage")
    }
    
    @IBAction func selectImage(_ sender: Any) {
        
        delegate?.presentPicker()
    }
    
    
}
extension ImageTableViewCell: ImageDelegate {
    
    func setImage(_ image: UIImage) {
        
        profileImageView.image = image
    }
}
