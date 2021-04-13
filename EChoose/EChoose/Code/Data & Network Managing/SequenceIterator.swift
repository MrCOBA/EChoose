//
//  SequenceIterator.swift
//  EChoose
//
//  Created by Oparin Oleg on 29.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit
import Foundation

class Offer: NSObject {
    
    var id: Int = -1
    var user: Int = -1
    
    var edLocation: String = ""
    var categoryid: Int = -1
    var address: Int = -1
    var serviceDescription: String = ""
    var price: Int = -1
    var isTutor: Bool = true
    var isActive: Bool = true
    var types: [Int] = []
    var locationDefault: LocationDefault?
}

class UserDefault: NSObject {
    
    var id: Int = -1
    
    var firstName: String = ""
    var lastName: String = ""
    var age: Int = -1
    var isMale: Bool = true
    var email: String = ""
    var userDescription: String = ""
    var image: UIImage?
    var imageURL: String = ""
}

class SequenceIterator {
    
    var globalManager: GlobalManager = GlobalManager.shared
    var locationsManager: LocationsManager = LocationsManager.shared
    var offers: [Offer] = []
    var usersDefault: [UserDefault] = []
    var offersPart: [Offer] = []
    var locationsDefault: [LocationDefault] = []
    
    func decodeOffers() {

        if offersPart.count > 0 {
            
            iterativeLocationsInit(maxIter: offersPart.count, iter: 0)
        } else {
            
            globalManager.postNotification(Notification.Name("dataUpdated"))
        }
       
    }
    
    func nextIterate(with iterativeFunction: ((Int, Int) -> Void), for iter: Int, _ maxIter: Int, completition: (() -> Void)?) {
        
        if iter < maxIter - 1 {
            
            iterativeFunction(maxIter, iter + 1)
            
        } else {
            
            if let completition = completition {
                
                completition()
            }
        }
    }
    
    func iterativeLocationsInit(maxIter: Int, iter: Int) {
        
        if let url = URL(string: "\(globalManager.apiURL)/address/\(offersPart[iter].address)/") {
            
            globalManager.GET(url: url, data: nil, withSerializer: locationSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                
                if let locationDefault = globalManager.buffer as? LocationDefault {
                    
                    offersPart[iter].locationDefault = locationDefault
                    globalManager.buffer = nil
                }
                
                nextIterate(with: iterativeLocationsInit, for: iter, maxIter, completition: {
                    
                    locationsManager.iterativeGeoDecoder(from: locationsDefault, maxIter: locationsDefault.count, iter: 0, completition: {
                        
                        iterativeUsersInit(maxIter: offersPart.count, iter: 0)
                    })
                })
            })
            
        } else {
            
            nextIterate(with: iterativeLocationsInit, for: iter, maxIter, completition: {[unowned self] in
                
                locationsManager.iterativeGeoDecoder(from: locationsDefault, maxIter: locationsDefault.count, iter: 0, completition: {
                    
                    iterativeUsersInit(maxIter: offersPart.count, iter: 0)
                })
            })
        }
    }

    
    func iterativeUsersInit(maxIter: Int, iter: Int) {
        
        if let url = URL(string: "\(globalManager.apiURL)/profile/\(offersPart[iter].user)/") {
            
            globalManager.GET(url: url, data: nil, withSerializer: userSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                
                nextIterate(with: iterativeUsersInit, for: iter, maxIter, completition: {
                    
                    iterativeImagesInit(maxIter: usersDefault.count, iter: 0)
                })
            })
        } else {
            
            nextIterate(with: iterativeUsersInit, for: iter, maxIter, completition: {[unowned self] in
                
                iterativeImagesInit(maxIter: usersDefault.count, iter: 0)
            })
        }
    }
    
    func iterativeImagesInit(maxIter: Int, iter: Int) {
        
        if usersDefault[iter].imageURL != "" {

            guard let url = URL(string: "\(globalManager.apiURL)/\(usersDefault[iter].imageURL)/") else {
                return
            }
            
            globalManager.downloadImage(from: url, completition: { [unowned self] in
                
                if let image = globalManager.buffer as? UIImage {
                    usersDefault[iter].image = image
                }
                
                nextIterate(with: iterativeImagesInit, for: iter, maxIter, completition: {
                    globalManager.postNotification(Notification.Name("dataUpdated"))
                })
            })
            
        } else {

            nextIterate(with: iterativeImagesInit, for: iter, maxIter, completition: { [unowned self] in
                globalManager.postNotification(Notification.Name("dataUpdated"))
            })
        }
    }
}
extension SequenceIterator {
    
    func offersSerializer(_ data: Any) -> Bool {
        
        guard let jsonArray = globalManager.perform(data: data, isArray: true) as? [[String : Any]] else {
            return false
        }
        
        for json in jsonArray {
            
            let offer = Offer()
            
            if let id = json["id"] as? Int{
                offer.id = id
            }
            
            if let userid = json["user"] as? Int {
                offer.user = userid
            }
            
            if let edLocation = json["location"] as? String {
                offer.edLocation = edLocation
            }
            
            if let categoryid = json["category"] as? Int {
                offer.categoryid = categoryid
            }
            
            if let description = json["description"] as? String {
                offer.serviceDescription = description
            }
               
            if let price = json["price"] as? Int {
                offer.price = price
            }
            
            if let isTutor = json["isTutor"] as? Bool {
                offer.isTutor = isTutor
            }
            
            if let types = json["types"] as? [Int] {
                offer.types = types
            }
               
            if let isActive = json["isActive"] as? Bool {
                offer.isActive = isActive
            }
            
            
            if let addressid = json["address"] as? Int {
                offer.address = addressid
            }
            
            offers.insert(offer, at: 0)
        }
        
        return true
    }
    
    func locationSerializer(_ data: Any) -> Bool {
        
        guard let json = globalManager.perform(data: data) as? [String : Any] else {
            return false
        }
        
        if let id = json["id"] as? Int,
           let name = json["name"] as? String,
           let latitude = json["latitude"] as? Double,
           let longitude = json["longitude"] as? Double {
            
            let locationDefault = LocationDefault(latitude, longitude)
            locationDefault.id = id
            locationDefault.name = name
            locationsDefault.append(locationDefault)
            
            globalManager.buffer = locationDefault
        }
        
        return true
    }
    
    func userSerializer(_ data: Any) -> Bool {
        
        guard let json = globalManager.perform(data: data) as? [String : Any] else {
            return false
        }
        
        let userDefault = UserDefault()
        
        if let id = json["id"] as? Int {
            userDefault.id = id
        }
        
        if let userData = json["user"] as? [String : Any] {
            
            if let firstname = userData["first_name"] as? String {
                userDefault.firstName = firstname
            }
            
            if let lastname = userData["last_name"] as? String {
                userDefault.lastName = lastname
            }
            
            if let email = userData["email"] as? String {
                userDefault.email = email
            }
        }
        
        if let isMale = json["isMale"] as? Bool {
            userDefault.isMale = isMale
        }
        
        if let description = json["description"] as? String {
            userDefault.userDescription = description
        }
    
        if let birthDate = json["birth_date"] as? String {
            userDefault.age = globalManager.dateToAge(date: birthDate)
        }
              
        if let image = json["image"] as? String {
            userDefault.imageURL = image
        }
            
        usersDefault.append(userDefault)
        
        return true
    }
}
