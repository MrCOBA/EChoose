//
//  ActivitiesManager.swift
//  EChoose
//
//  Created by Oparin Oleg on 29.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import Foundation
import UIKit

enum ActivityType {
    case match
    case archive
}

protocol Activity {
    
    func loadActivity()
    func size() -> Int
    func get(_ index: Int) -> Offer?
    func get(_ index: Int) -> UserDefault?
    func clear()
}

class MatchesActivity: SequenceIterator, Activity {
    
    func loadActivity() {
        
        guard let url = URL(string: "\(globalManager.apiURL)/offers/matches/") else {
            return
        }
        
        globalManager.GET(url: url, data: nil, withSerializer: offersSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            offersPart = offers
            decodeOffers()
        })
    }
    
    func size() -> Int {
        
        return offersPart.count
    }
    
    func get(_ index: Int) -> Offer? {
        
        if index >= 0 && index < size() {
            
            return offersPart[index]
        }
        
        return nil
    }
    
    func get(_ index: Int) -> UserDefault? {
        
        if index >= 0 && index < size() {
            
            return usersDefault[index]
        }
        
        return nil
    }
    
    func clear() {
        
        locationsDefault = []
        offers = []
        offersPart = []
        usersDefault = []
    }
}

class ArchivesActivity: SequenceIterator, Activity {
    
    var isLoaded: Bool = false
    
    func loadActivity() {

        guard let url = URL(string: "\(globalManager.apiURL)/offers/archives/") else {
            return
        }
        
        globalManager.GET(url: url, data: nil, withSerializer: offersSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            offersPart = offers
            decodeOffers()
        })
    }
    
    func size() -> Int {
        
        return offersPart.count
    }
    
    func get(_ index: Int) -> Offer? {
        
        if index >= 0 && index < size() {
            
            return offersPart[index]
        }
        
        return nil
    }
    
    func get(_ index: Int) -> UserDefault? {
        
        if index >= 0 && index < size() {
            
            return usersDefault[index]
        }
        
        return nil
    }
    
    func clear() {
        
        locationsDefault = []
        offers = []
        offersPart = []
        usersDefault = []
    }
}

class ActivitiesManager {
    
    private var activities: [ActivityType : Activity] = [:]
    var loadComplete: Bool = false
    
    static var shared: ActivitiesManager = {
        let instance = ActivitiesManager()
        return instance
    }()
    
    private init() {
        
        activities[.match] = MatchesActivity()
        activities[.archive] = ArchivesActivity()
    }
    
    subscript (activityType: ActivityType) -> Activity? {
        
        get {
            return activities[activityType]
        }
    }
}
