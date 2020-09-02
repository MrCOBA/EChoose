//
//  Service+CoreDataProperties.swift
//  EChoose
//
//  Created by Oparin Oleg on 01.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//
//

import Foundation
import CoreData


extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var cost: Int16
    @NSManaged public var descript: String?
    @NSManaged public var hard: Int16
    @NSManaged public var isActivated: Bool
    @NSManaged public var subject: String?
    @NSManaged public var type: String?
    @NSManaged public var servicesToUser: User?

}
