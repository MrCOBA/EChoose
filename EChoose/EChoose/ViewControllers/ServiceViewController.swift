//
//  ServiceViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 14.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var communicationAndSubjectLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var educationTypesCollectionView: UICollectionView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: CustomTextView!
    @IBOutlet weak var deleteButton: CustomButton!
    @IBOutlet weak var editButton: CustomButton!
    
    private var serviceTitle: String?
    private var serviceSubtitle: String?
    private var collectionData: [String] = []
    var servicesManager: ServicesManager = ServicesManager.shared
    var locationsManager: LocationsManager = LocationsManager.shared
    var service: Service?
    var serviceDefault: ServiceDefault?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = serviceTitle
        subtitleLabel.text = serviceSubtitle
        
        if let serviceDefault = serviceDefault {
            
            let category = servicesManager.categories.first(where: {category in return category.id == serviceDefault.categoryid})
            let edLocationType = servicesManager.edLocationTypes.first(where: {edLocationType in return edLocationType == serviceDefault.edLocation})
            let serviceTypes = servicesManager.serviceTypes.filter({serviceType in return serviceDefault.types.contains(serviceType.id)})
            collectionData = serviceTypes.map({serviceType in return serviceType.name})
            if serviceDefault.addressid == -1 {
                locationNameLabel.text = "No pinned Location"
                locationLabel.text = "Empty"
            } else {
                
                if let index = locationsManager.id2index(serviceDefault.addressid) {
                    locationNameLabel.text = "\(locationsManager.locationsDefault[index].name):"
                    locationLabel.text = locationsManager.locationsDefault[index].toString()
                } else {
                    
                    locationNameLabel.text = "No pinned Location"
                    locationLabel.text = "Empty"
                }
            }
            
            if let category = category,
               let edLocationType = edLocationType {
                communicationAndSubjectLabel.text = "\(category.name), \(edLocationType)"
                descriptionTextView.text = serviceDefault.description
                costLabel.text = "Price: \(serviceDefault.price)₽"
            }
            
        }
        
        educationTypesCollectionView.delegate = self
        educationTypesCollectionView.dataSource = self
        educationTypesCollectionView.register(UINib(nibName: EducationTypeCell.identifier, bundle: nil), forCellWithReuseIdentifier: EducationTypeCell.identifier)
    }

    func setViewController(_ title: String, _ subtitle: String, _ serviceDefault: ServiceDefault) {
        
        serviceTitle = title
        serviceSubtitle = subtitle
        self.serviceDefault = serviceDefault
    }
}
extension ServiceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = educationTypesCollectionView.dequeueReusableCell(withReuseIdentifier: EducationTypeCell.identifier, for: indexPath) as! EducationTypeCell
        
        cell.setCell(collectionData[indexPath.row])
        
        return cell
    }
}
extension ServiceViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionCellWidth = 83 + (collectionData[indexPath.row].count) * 15 + 10
        
        return CGSize(width: CGFloat(collectionCellWidth), height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}
