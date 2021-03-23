//
//  Service+CoreDataProperties.swift
//  EChoose
//
//  Created by Oparin Oleg on 19.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//
//

import Foundation
import CoreData


extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var price: Int32
    @NSManaged public var descript: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var isTutor: Bool
    @NSManaged public var serviceTypes: [Int]?
    @NSManaged public var category: Int32
    @NSManaged public var edLocationType: String?
    @NSManaged public var id: Int32
    @NSManaged public var location: Location?
    @NSManaged public var profile: Profile?

}

extension Service : Identifiable {

}
