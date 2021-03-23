//
//  Location+CoreDataProperties.swift
//  EChoose
//
//  Created by Oparin Oleg on 19.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var id: Int32
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var profile: Profile?
    @NSManaged public var services: NSOrderedSet?

}

// MARK: Generated accessors for services
extension Location {

    @objc(insertObject:inServicesAtIndex:)
    @NSManaged public func insertIntoServices(_ value: Service, at idx: Int)

    @objc(removeObjectFromServicesAtIndex:)
    @NSManaged public func removeFromServices(at idx: Int)

    @objc(insertServices:atIndexes:)
    @NSManaged public func insertIntoServices(_ values: [Service], at indexes: NSIndexSet)

    @objc(removeServicesAtIndexes:)
    @NSManaged public func removeFromServices(at indexes: NSIndexSet)

    @objc(replaceObjectInServicesAtIndex:withObject:)
    @NSManaged public func replaceServices(at idx: Int, with value: Service)

    @objc(replaceServicesAtIndexes:withServices:)
    @NSManaged public func replaceServices(at indexes: NSIndexSet, with values: [Service])

    @objc(addServicesObject:)
    @NSManaged public func addToServices(_ value: Service)

    @objc(removeServicesObject:)
    @NSManaged public func removeFromServices(_ value: Service)

    @objc(addServices:)
    @NSManaged public func addToServices(_ values: NSOrderedSet)

    @objc(removeServices:)
    @NSManaged public func removeFromServices(_ values: NSOrderedSet)

}

extension Location : Identifiable {

}
