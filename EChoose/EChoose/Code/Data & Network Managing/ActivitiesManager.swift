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
}

class MatchesActivity: SequenceIterator, Activity {
    
    func loadActivity() {
        
        guard let url = URL(string: "\(globalManager.apiURL)/offers/matches/") else {
            return
        }
        
        globalManager.GET(url: url, data: nil, withSerializer: offersSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            decodeOffers()
        })
    }
}

class ArchivesActivity: SequenceIterator, Activity {
    
    func loadActivity() {
        
        guard let url = URL(string: "\(globalManager.apiURL)/offers/archives/") else {
            return
        }
        
        globalManager.GET(url: url, data: nil, withSerializer: offersSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            decodeOffers()
        })
    }
}

class ActivitiesManager {
    
    private var activities: [ActivityType : Activity] = [:]
    
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
