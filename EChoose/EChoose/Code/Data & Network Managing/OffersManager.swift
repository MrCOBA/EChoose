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
    
    var findTutor: Bool = false
    var minPrice: Int = 100
    var maxPrice: Int = 10000
    var distance: Int = 10000
}

class OfferQueue: SequenceIterator {
    
    var queue = DispatchQueue(label: "COBA.Inc.EChoose.offersQueue", qos: .userInteractive, attributes: .concurrent)
    var filter: Filter = Filter()
    var isPinging: Bool = false
    
    func next() -> (Offer, UserDefault)? {
        
        if offersPart.count > 0 {
            let offer = offersPart[offersPart.count - 1]
            let user = usersDefault[usersDefault.count - 1]
            offersPart.remove(at: offersPart.count - 1)
            usersDefault.remove(at: usersDefault.count - 1)
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
        
        globalManager.POST(url: url, data: jsonData, withSerializer: offersSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            if offers.count > 0 {
                deinitSearch()
                
                while offers.count > 0 && offersPart.count < 10 {
                    
                    offersPart.append(offers[0])
                    offers.remove(at: 0)
                    
                }
                decodeOffers()
                
            } else if isPinging {
                
                queue.asyncAfter(deadline: .now() + 20) {[unowned self] in
                    update()
                }
            }
        })
    }
    
    func clear() {
        
        offers = []
        usersDefault = []
        offersPart = []
        locationsDefault = []
    }
    
    func initSearch() {
        isPinging = true
        update()
    }
    
    func deinitSearch() {
        
        isPinging = false
    }
    
}

class OffersManager {
    
    static var shared: OffersManager = {
        let instance = OffersManager()
        return instance
    }()
    var offersQueue: OfferQueue
    
    private init() {
        
        offersQueue = OfferQueue()
    }
}
