//
//  Profile+CoreDataProperties.swift
//  EChoose
//
//  Created by Oparin Oleg on 19.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var age: Int32
    @NSManaged public var descript: String?
    @NSManaged public var email: String?
    @NSManaged public var firstname: String?
    @NSManaged public var id: Int32
    @NSManaged public var image: Data?
    @NSManaged public var lastname: String?
    @NSManaged public var sex: Bool
    @NSManaged public var dialogs: NSOrderedSet?
    @NSManaged public var locations: NSOrderedSet?
    @NSManaged public var services: NSOrderedSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for dialogs
extension Profile {

    @objc(insertObject:inDialogsAtIndex:)
    @NSManaged public func insertIntoDialogs(_ value: Dialog, at idx: Int)

    @objc(removeObjectFromDialogsAtIndex:)
    @NSManaged public func removeFromDialogs(at idx: Int)

    @objc(insertDialogs:atIndexes:)
    @NSManaged public func insertIntoDialogs(_ values: [Dialog], at indexes: NSIndexSet)

    @objc(removeDialogsAtIndexes:)
    @NSManaged public func removeFromDialogs(at indexes: NSIndexSet)

    @objc(replaceObjectInDialogsAtIndex:withObject:)
    @NSManaged public func replaceDialogs(at idx: Int, with value: Dialog)

    @objc(replaceDialogsAtIndexes:withDialogs:)
    @NSManaged public func replaceDialogs(at indexes: NSIndexSet, with values: [Dialog])

    @objc(addDialogsObject:)
    @NSManaged public func addToDialogs(_ value: Dialog)

    @objc(removeDialogsObject:)
    @NSManaged public func removeFromDialogs(_ value: Dialog)

    @objc(addDialogs:)
    @NSManaged public func addToDialogs(_ values: NSOrderedSet)

    @objc(removeDialogs:)
    @NSManaged public func removeFromDialogs(_ values: NSOrderedSet)

}

// MARK: Generated accessors for locations
extension Profile {

    @objc(insertObject:inLocationsAtIndex:)
    @NSManaged public func insertIntoLocations(_ value: Location, at idx: Int)

    @objc(removeObjectFromLocationsAtIndex:)
    @NSManaged public func removeFromLocations(at idx: Int)

    @objc(insertLocations:atIndexes:)
    @NSManaged public func insertIntoLocations(_ values: [Location], at indexes: NSIndexSet)

    @objc(removeLocationsAtIndexes:)
    @NSManaged public func removeFromLocations(at indexes: NSIndexSet)

    @objc(replaceObjectInLocationsAtIndex:withObject:)
    @NSManaged public func replaceLocations(at idx: Int, with value: Location)

    @objc(replaceLocationsAtIndexes:withLocations:)
    @NSManaged public func replaceLocations(at indexes: NSIndexSet, with values: [Location])

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSOrderedSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSOrderedSet)

}

// MARK: Generated accessors for services
extension Profile {

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

extension Profile : Identifiable {

}
