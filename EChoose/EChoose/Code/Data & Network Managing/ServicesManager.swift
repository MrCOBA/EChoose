//
//  ServicesManager.swift
//  EChoose
//
//  Created by Oparin Oleg on 19.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct ServiceType {
    
    var id: Int
    var name: String
}
struct Category {
    
    var id: Int
    var name: String
}

enum ServiceDefaultField {
    
    case addressID
    case edLocation
    case categoryID
    case description
    case price
    case isTutor
    case serviceTypes
    case isActive
}

class ServiceDefault {
    
    var addressid: Int
    var edLocation: String
    var categoryid: Int
    var description: String
    var price: Int
    var isTutor: Bool
    var types: [Int]
    var isActive: Bool
    
    init(addressid: Int = -1,
         edLocation: String = "",
         categoryid: Int = -1,
         description: String = "",
         price: Int = -1,
         isTutor: Bool = true,
         types: [Int] = [],
         isActive: Bool = true) {
        
        self.addressid = addressid
        self.edLocation = edLocation
        self.categoryid = categoryid
        self.description = description
        self.price = price
        self.isTutor = isTutor
        self.types = types
        self.isActive = isActive
    }
}

class ServicesManager {
    
    static var shared: ServicesManager = {
        let instance = ServicesManager()
        return instance
    }()
    
    var context: NSManagedObjectContext?
    var globalManager: GlobalManager = GlobalManager.shared
    var locationsManager: LocationsManager = LocationsManager.shared
    
    var serviceTypes: [ServiceType]
    var categories: [Category]
    var edLocationTypes: [String]
    
    private init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        serviceTypes = []
        categories = []
        edLocationTypes = []
    }
    
    func loadMetaData(completition: (() -> Void)? = nil) {
        
        serviceTypes = []
        categories = []
        edLocationTypes = []
        
        
        guard let url = URL(string: "\(globalManager.apiURL)/service/location_types/") else {
            return
        }
        
        globalManager.GET(url: url, data: nil, withSerializer: edLocationTypesSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            guard let url = URL(string: "\(globalManager.apiURL)/service/service_types/") else {
                return
            }
            
            globalManager.GET(url: url, data: nil, withSerializer: serviceTypesSerializer(_:), isAuthorized: true, completition: {
                
                guard let url = URL(string: "\(globalManager.apiURL)/service/categories/") else {
                    return
                }
                
                globalManager.GET(url: url, data: nil, withSerializer: categoriesSerializer(_:), isAuthorized: true, completition: completition)
            })
        })
    }
    
    func loadData(completition: (() -> Void)? = nil) {
        
        locationsManager.loadData(completition: {[unowned self] in
            
            guard let url = URL(string: "\(globalManager.apiURL)/service/") else {
                return
            }
            
            globalManager.GET(url: url, data: nil, withSerializer: globalManager.servicesSerializer(_:), isAuthorized: true, completition: completition)
        })
    }
    
    func addService(_ serviceDefault: ServiceDefault, completition: (() -> Void)? = nil) {
        
        guard let jsonData = globalManager.serviceJSON(from: serviceDefault) else {
            return
        }
        
        guard let url = URL(string: "\(globalManager.apiURL)/service/") else {
            return
        }
        
        globalManager.POST(url: url, data: jsonData, withSerializer: globalManager.serviceSerializer(_:), isAuthorized: true, completition: completition)
    }
    
    func replaceService(_ serviceDefault: ServiceDefault, with index: Int, completition: (() -> Void)? = nil) {
        
        guard let context = context,
              let user = globalManager.user,
              let profile = user.profile,
              let locations = profile.locations,
              let jsonData = globalManager.serviceJSON(from: serviceDefault),
              let id = index2id(index) else {
            return
        }
        
        guard let url = URL(string: "\(globalManager.apiURL)/service/\(id)/") else {
            return
        }
        
        globalManager.PUT(url: url, data: jsonData, withSerializer: nil, isAuthorized: true, completition: {[unowned self] in
            
            let service = Service(context: context)
            
            if let index = locationsManager.id2index(serviceDefault.addressid),
                  let location = locations[index] as? Location {
                service.location = location
            }
            
            
            service.id = Int32(id)
            service.edLocationType = serviceDefault.edLocation
            service.category = Int32(serviceDefault.categoryid)
            service.descript = serviceDefault.description
            service.price = Int32(serviceDefault.price)
            service.isTutor = serviceDefault.isTutor
            service.serviceTypes = serviceDefault.types
            service.isActive = serviceDefault.isActive
            profile.replaceServices(at: index, with: service)
            
            globalManager.saveData()
            
            if let completition = completition {
                completition()
            }
        })
    }
    
    func deleteService(with id: Int, completition: (() -> Void)? = nil) {
        
        guard let context = context,
              let user = globalManager.user,
              let profile = user.profile,
              let services = profile.services else {
            return
        }
        
        guard let url = URL(string: "\(globalManager.apiURL)/service/\(id)/") else {
            return
        }
        
        globalManager.DELETE(url: url, data: nil, withSerializer: nil, isAuthorized: true, completition: {[unowned self] in
            
            guard let index = id2index(id),
                  let service = services[index] as? Service else {
                return
            }
            profile.removeFromServices(service)
            context.delete(service)
            globalManager.saveData()
            if let completition = completition {
                completition()
            }
        })
    }
    
    func defaultCopy(of service: Service) -> ServiceDefault {
        
        let serviceCopy = ServiceDefault()
        
        serviceCopy.addressid = Int(service.location?.id ?? -1)
        serviceCopy.edLocation = service.edLocationType ?? ""
        serviceCopy.categoryid = Int(service.category)
        serviceCopy.description = service.descript ?? ""
        serviceCopy.price = Int(service.price)
        serviceCopy.isTutor = service.isTutor
        serviceCopy.types = service.serviceTypes ?? []
        serviceCopy.isActive = service.isActive
        
        
        return serviceCopy
    }
    
    func id2index(_ id: Int) -> Int? {
        
        if let user = globalManager.user,
           let profile = user.profile,
           let services = profile.services {
            
            for i in 0..<services.count {
                
                if let service = services[i] as? Service {
                    
                    if service.id == id {
                        return i
                    }
                }
            }
        }
        
        return nil
    }
    
    func index2id(_ index: Int) -> Int? {
        
        if let user = globalManager.user,
           let profile = user.profile,
           let services = profile.services{
            
            if index < services.count && index >= 0 {
                
                if let service = services[index] as? Service {
                    return Int(service.id)
                }
            }
        }
        
        return nil
    }
}
//MARK: - Parsers
extension ServicesManager {
    
    func edLocationTypesSerializer(_ data: Any) -> Bool {
        
        guard let json = globalManager.perform(data: data) as? [String : Any] else {
            return false
        }
        
        guard let edLocationTypes = json["answer"] as? [String] else {
            return false
        }
        self.edLocationTypes = edLocationTypes
        
        return true
    }
    
    func serviceTypesSerializer(_ data: Any) -> Bool {
        
        guard let jsonArray = globalManager.perform(data: data, isArray: true) as? [[String : Any]] else {
            return false
        }
        
        for json in jsonArray {
            
            guard let id = json["id"] as? Int,
                  let name = json["name"] as? String else {
                continue
            }
            serviceTypes.append(ServiceType(id: id, name: name))
        }
        
        return true
    }
    
    func categoriesSerializer(_ data: Any) -> Bool {
        
        guard let jsonArray = globalManager.perform(data: data, isArray: true) as? [[String : Any]] else {
            return false
        }
        
        for json in jsonArray {
            
            guard let id = json["id"] as? Int,
                  let name = json["name"] as? String else {
                continue
            }
            categories.append(Category(id: id, name: name))
        }
        
        return true
    }
}
