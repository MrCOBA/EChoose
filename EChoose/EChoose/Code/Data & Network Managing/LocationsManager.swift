//
//  LocationsManager.swift
//  EChoose
//
//  Created by Oparin Oleg on 18.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class LocationDefault {
    
    var id: Int?
    var name: String = "No Loaction Name"
    var additionalStreetInfo: String?
    var street: String?
    var city: String?
    var zipcode: String?
    var country: String?
    
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    
    init(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ additionalStreetInfo: String, _ street: String, _ city: String, _ zipcode: String, _ country: String, _ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        
        self.additionalStreetInfo = additionalStreetInfo
        self.street = street
        self.city = city
        self.zipcode = zipcode
        self.country = country
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func toString() -> String {
        
        if let country = self.country,
           let city = self.city {
            
            return "\(country), \(city),\n\(self.street ?? ""), \(self.additionalStreetInfo ?? "")"
        }
        
        return "Empty Location"
    }
}

class LocationsManager {
    
    static var shared: LocationsManager = {
        let instance = LocationsManager()
        return instance
    }()
    
    var context: NSManagedObjectContext?
    var locationsDefault: [LocationDefault]
    var globalManager: GlobalManager = GlobalManager.shared
    
    private init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        locationsDefault = []
    }
    
    func loadData(completition: (() -> Void)? = nil) {
        
        locationsDefault = []
        
        guard let url = URL(string: "\(globalManager.apiURL)/address/") else {
            return
        }
        
        globalManager.GET(url: url, data: nil, withSerializer: globalManager.locationsSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            guard let user = globalManager.user,
                  let profile = user.profile,
                  let locations = profile.locations else {
                return
            }
            
            for i in 0..<locations.count {
                
                guard let location = locations[i] as? Location,
                      let name = location.name else {
                    continue
                }
                
                let latitude = CLLocationDegrees(location.latitude)
                let longitude = CLLocationDegrees(location.longitude)
                let locationDefault = LocationDefault(latitude, longitude)
                locationDefault.id = Int(location.id)
                locationDefault.name = name
                
                locationsDefault.append(locationDefault)
            }
            
            iterativeGeoDecoder(from: locationsDefault, maxIter: locationsDefault.count, iter: 0, completition: completition)
        })
    }
    
    //MARK: - CRUD (Create)
    func addLocation(_ locationDefault: LocationDefault, completition: (() -> Void)? = nil) {
        
        let jsonData: [String : Any] = ["name" : locationDefault.name,
                                        "latitude" : locationDefault.latitude as Double,
                                        "longitude" : locationDefault.longitude as Double]
        
        let json = (try? JSONSerialization.data(withJSONObject: jsonData, options: []))
        
        guard let url = URL(string: "\(globalManager.apiURL)/address/") else {
            return
        }
        
        globalManager.POST(url: url, data: json, withSerializer: globalManager.locationSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            locationsDefault.append(locationDefault)
            if let completition = completition {
                completition()
            }
        })
    }
    
    //MARK: - CRUD (Update)
    func replaceLocation(_ locationDefault: LocationDefault, with index: Int, completition: (() -> Void)? = nil) {
        
        guard let context = context,
              let user = globalManager.user,
              let profile = user.profile,
              let locations = profile.locations else {
            return
        }
        
        guard let id = index2id(index) else {
            return
        }
        
        let jsonData: [String : Any] = ["name" : locationDefault.name,
                                        "latitude" : locationDefault.latitude as Double,
                                        "longitude" : locationDefault.longitude as Double]
        
        let json = (try? JSONSerialization.data(withJSONObject: jsonData, options: []))
        
        guard let url = URL(string: "\(globalManager.apiURL)/address/\(id)/") else {
            return
        }
        
        globalManager.PUT(url: url, data: json, withSerializer: nil, isAuthorized: true, completition: {[unowned self] in
            
            locationsDefault[index] = locationDefault
            
            for i in 0..<locations.count {
                
                if let location = locations[i] as? Location {
                    if location.id == id {
                        
                        let newLocation = Location(context: context)
                        newLocation.name = locationDefault.name
                        newLocation.latitude = locationDefault.latitude
                        newLocation.longitude = locationDefault.longitude
                        
                        profile.replaceLocations(at: i, with: newLocation)
                        context.delete(location)
                        break
                    }
                }
            }
            globalManager.saveData()
            if let completition = completition {
                completition()
            }
        })
        
    }
    
    //MARK: - CRUD (Delete)
    func deleteLocation(with id: Int, completition: (() -> Void)? = nil) {
        
        guard let context = context,
              let user = globalManager.user,
              let profile = user.profile,
              let locations = profile.locations else {
            return
        }
        
        guard let index = id2index(id) else {
            return
        }
        
        guard let url = URL(string: "\(globalManager.apiURL)/address/\(id)/") else {
            return
        }
        
        globalManager.DELETE(url: url, data: nil, withSerializer: nil, isAuthorized: true, completition: {[unowned self] in
            
            guard let location = locations[index] as? Location else {
                return
            }
            locationsDefault.remove(at: index)
            profile.removeFromLocations(location)
            context.delete(location)

            globalManager.saveData()
            if let completition = completition {
                completition()
            }
        })
        
    }
    
    //MARK: - Help Functions
    func id2index(_ id: Int) -> Int? {
        
        for (i, locationDefault) in locationsDefault.enumerated() {
            
            if locationDefault.id == id {
                return i
            }
        }
        
        return nil
    }
    
    func index2id(_ index: Int) -> Int? {
        
        if index < locationsDefault.count && index >= 0 {
            return locationsDefault[index].id
        }
        
        return nil
    }
    
    func copy(of locationDefault: LocationDefault) -> LocationDefault {
        
        let copyLocation = LocationDefault(locationDefault.additionalStreetInfo ?? "",
                                           locationDefault.street ?? "",
                                           locationDefault.city ?? "",
                                           locationDefault.zipcode ?? "",
                                           locationDefault.country ?? "",
                                           locationDefault.latitude,
                                           locationDefault.longitude)
        copyLocation.id = locationDefault.id
        copyLocation.name = locationDefault.name
        return copyLocation
    }
    
    func iterativeGeoDecoder(from locations: [LocationDefault], maxIter: Int, iter: Int, completition: (() -> Void)?) {
        
        if maxIter == 0 {
            
            guard let completition = completition else {
                return
            }
            completition()
            
        } else {
            
            let location = CLLocation(latitude: locations[iter].latitude, longitude: locations[iter].longitude)
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location, completionHandler: {[unowned self] placemarks, error -> Void in
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                
                // Location name
                if let locationName = placeMark.location {
                    print(locationName)
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    locations[iter].street = street
                }
                // House number... i.e.
                if let additionalStreetInfo = placeMark.subThoroughfare {
                    locations[iter].additionalStreetInfo = additionalStreetInfo
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    locations[iter].city = city
                }
                // Zip code
                if let zip = placeMark.isoCountryCode {
                    locations[iter].zipcode = zip
                }
                // Country
                if let country = placeMark.country {
                    locations[iter].country = country
                }
                
                if iter + 1 < maxIter {
                    iterativeGeoDecoder(from: locations, maxIter: maxIter, iter: iter + 1, completition: completition)
                } else {
                    guard let completition = completition else {
                        return
                    }
                    completition()
                }
            })
        }
    }
}
//MARK: - Notifications
extension LocationsManager {
 
    func postNotification(_ name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
    }
    
    func postNotification(_ name: Notification.Name, userInfo: [String : Any]) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
}
