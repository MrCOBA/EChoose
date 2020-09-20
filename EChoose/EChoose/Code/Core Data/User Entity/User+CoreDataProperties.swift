//
//  User+CoreDataProperties.swift
//  EChoose
//
//  Created by Oparin Oleg on 05.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var city: String?
    @NSManaged public var descript: String?
    @NSManaged public var email: String?
    @NSManaged public var fullname: String?
    @NSManaged public var image: Data?
    @NSManaged public var password: String?
    @NSManaged public var role: String?
    @NSManaged public var username: String?
    @NSManaged public var dialogs: NSOrderedSet?
    @NSManaged public var services: NSOrderedSet?

}

// MARK: Generated accessors for dialogs
extension User {

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

// MARK: Generated accessors for services
extension User {

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
