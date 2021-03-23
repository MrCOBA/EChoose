//
//  OffersManager.swift
//  EChoose
//
//  Created by Oparin Oleg on 22.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import Foundation
import UIKit

class Filter {
    
    var findTutor: Bool = true
    var minPrice: Int = 0
    var maxPrice: Int = 10000
    var distance: Int = 10000
}

class Offer {
    
    var id: Int = -1
    var user: Int = -1
    
    var edLocation: String = ""
    var categoryid: Int = -1
    var address: Int = -1
    var description: String?
    var price: Int = -1
    var isTutor: Bool = true
    var isActive: Bool = true
    var types: [Int] = []
    
    var locationDefault: LocationDefault?
}

class OfferUser {
    
    var id: Int = -1
    
    var firstName: String = ""
    var lastName: String = ""
    var age: Int = -1
    var isMale: Bool = true
    var description: String?
    var image: UIImage?
    var imageURL: String = ""
}

class OfferQueue {
    
    var globalManager: GlobalManager = GlobalManager.shared
    var locationsManager: LocationsManager = LocationsManager.shared
    fileprivate var queue = DispatchQueue(label: "COBA.Inc.EChoose.offersQueue", qos: .userInteractive, attributes: .concurrent)
    var filter: Filter = Filter()
    var offers: [Offer] = []
    var offerUsers: [OfferUser] = []
    var offersPart: [Offer] = []
    var locationsDefault: [LocationDefault] = []
    var isPinging: Bool = false
    
    func add(offers: [Offer]) {
        for offer in offers {
            self.offers.insert(offer, at: 0)
        }
    }
    
    func next() -> (Offer, OfferUser)? {
        
        if offersPart.count > 0 {
            let offer = offersPart[offersPart.count - 1]
            let user = offerUsers[offersPart.count - 1]
            offersPart.remove(at: offersPart.count - 1)
            offerUsers.remove(at: offersPart.count - 1)
            return (offer, user)
        }
        
        globalManager.postNotification(Notification.Name("offersStartUpdating"))
        nextPart()
        
        return nil
    }
    
    func nextPart() {
        
        while offers.count > 0 && offersPart.count < 10 {
            
            offersPart.append(offers[0])
            offers.remove(at: 0)
        }
        
        if offersPart.count == 0 {
            
            initSearch()
        } else {
            
            decodeOffers()
        }
    }
    
    
    func update() {
        
        guard let url = URL(string: "\(globalManager.apiURL)/offers/") else {
            return
        }
        
        guard let jsonData = globalManager.filterJSON(from: filter) else {
            return
        }
        
        globalManager.GET(url: url, data: jsonData, withSerializer: offersSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            if offers.count > 0 {
                deinitSearch()
                
                while offers.count > 0 && offersPart.count < 10 {
                    
                    offersPart.append(offers[0])
                    offers.remove(at: 0)
                    
                }
                decodeOffers()
                
            } else if isPinging {
                queue.asyncAfter(deadline: .now() + 60) {[unowned self] in
                    update()
                }
            }
        })
    }
    
    func decodeOffers() {
        
        iterativeLocationsInit(maxIter: offersPart.count, iter: 0)
    }
    
    func iterativeLocationsInit(maxIter: Int, iter: Int) {
        
        if let url = URL(string: "\(globalManager.apiURL)/address/\(offersPart[iter].address)/") {
            
            globalManager.GET(url: url, data: nil, withSerializer: locationSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                
                if iter < maxIter - 1 {
                    
                    iterativeLocationsInit(maxIter: maxIter, iter: iter + 1)
                    
                } else {
                    
                    locationsManager.iterativeGeoDecoder(from: locationsDefault, maxIter: locationsDefault.count, iter: 0, completition: {
                        
                        iterativeUsersInit(maxIter: offersPart.count, iter: 0)
                    })
                }
            })
            
        } else {
            
            if iter < maxIter - 1 {
                
                iterativeLocationsInit(maxIter: maxIter, iter: iter + 1)
                
            } else {
                
                locationsManager.iterativeGeoDecoder(from: locationsDefault, maxIter: locationsDefault.count, iter: 0, completition: {[unowned self] in
                    
                    iterativeUsersInit(maxIter: offersPart.count, iter: 0)
                })
            }
        }
    }
    
    func iterativeUsersInit(maxIter: Int, iter: Int) {
        
        if let url = URL(string: "\(globalManager.apiURL)/profile/\(offersPart[iter].user)/") {
            
            globalManager.GET(url: url, data: nil, withSerializer: userSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                
                if iter < maxIter - 1 {
                    
                    iterativeUsersInit(maxIter: maxIter, iter: iter + 1)
                } else {
                    
                    iterativeImagesInit(maxIter: offerUsers.count, iter: 0)
                }
            })
        } else {
            
            if iter < maxIter - 1 {
                
                iterativeUsersInit(maxIter: maxIter, iter: iter + 1)
            } else {
                
                iterativeImagesInit(maxIter: offerUsers.count, iter: 0)
            }
        }
    }
    
    func iterativeImagesInit(maxIter: Int, iter: Int) {
        
        if offerUsers[iter].imageURL != "" {
            
            guard let url = URL(string: "\(globalManager.apiURL)\(offerUsers[iter].imageURL)") else {
                return
            }
            
            DispatchQueue.global().async { [unowned self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            offerUsers[iter].image = image
                            
                            if iter < maxIter - 1 {
                                
                                iterativeImagesInit(maxIter: maxIter, iter: iter + 1)
                            } else {
                                
                                globalManager.postNotification(Notification.Name("offersUpdated"))
                            }
                        }
                    }
                }
            }
        } else {
            
            if iter < maxIter - 1 {
                
                iterativeImagesInit(maxIter: maxIter, iter: iter + 1)
            } else {
                
                globalManager.postNotification(Notification.Name("offersUpdated"))
            }
        }
    }
    
    func initSearch() {
        isPinging = true
        update()
    }
    
    func deinitSearch() {
        
        isPinging = false
    }
    
}
extension OfferQueue {
    
    func offersSerializer(_ data: Any) -> Bool {
        
        guard let jsonArray = globalManager.perform(data: data, isArray: true) as? [[String : Any]] else {
            return false
        }
        
        for json in jsonArray {
            if let id = json["id"] as? Int,
               let userid = json["user"] as? Int,
               let edLocation = json["location"] as? String,
               let categoryid = json["category"] as? Int,
               let description = json["description"] as? String,
               let price = json["price"] as? Int,
               let isTutor = json["isTutor"] as? Bool,
               let types = json["types"] as? [Int],
               let isActive = json["isActive"] as? Bool {
                
                let offer = Offer()
                
                offer.id = id
                offer.edLocation = edLocation
                offer.categoryid = categoryid
                offer.description = description
                offer.price = price
                offer.isTutor = isTutor
                offer.types = types
                offer.isActive = isActive
                offer.user = userid
                
                if let addressid = json["address"] as? Int {
                    offer.address = addressid
                }
                
                add(offers: [offer])
            }
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
            
            if let offer = offersPart.first(where: {offer in return offer.address == id}) {
                offer.locationDefault = LocationDefault(latitude, longitude)
                offer.locationDefault!.id = id
                offer.locationDefault!.name = name
                locationsDefault.append(offer.locationDefault!)
            }
        }
        
        return true
    }
    
    func userSerializer(_ data: Any) -> Bool {
        
        guard let json = globalManager.perform(data: data) as? [String : Any] else {
            return false
        }
        
        if let id = json["id"] as? Int,
              let firstname = json["first_name"] as? String,
              let lastname = json["last_name"] as? String,
              let isMale = json["isMale"] as? Bool,
              let description = json["description"] as? String,
              let birthDate = json["birth_date"] as? String,
              let image = json["image"] as? String {
            
            let offerUser = OfferUser()
            
            offerUser.id = id
            offerUser.firstName = firstname
            offerUser.lastName = lastname
            offerUser.age = globalManager.dateToAge(date: birthDate)
            offerUser.isMale = isMale
            offerUser.description = description
            offerUser.imageURL = image
            
            offerUsers.append(offerUser)
        }
        
        return true
    }
}

class OffersManager {
    
    static var shared: OffersManager = {
        let instance = OffersManager()
        return instance
    }()
    var filter: Filter
    var offersQueue: OfferQueue
    
    private init() {
        
        filter = Filter()
        offersQueue = OfferQueue()
    }
}
