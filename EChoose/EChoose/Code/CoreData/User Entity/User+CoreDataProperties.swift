//
//  User+CoreDataProperties.swift
//  EChoose
//
//  Created by Oparin Oleg on 01.09.2020.
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
    @NSManaged public var userToDialogs: NSSet?
    @NSManaged public var userToServices: NSSet?

}

// MARK: Generated accessors for userToDialogs
extension User {

    @objc(addUserToDialogsObject:)
    @NSManaged public func addToUserToDialogs(_ value: Dialog)

    @objc(removeUserToDialogsObject:)
    @NSManaged public func removeFromUserToDialogs(_ value: Dialog)

    @objc(addUserToDialogs:)
    @NSManaged public func addToUserToDialogs(_ values: NSSet)

    @objc(removeUserToDialogs:)
    @NSManaged public func removeFromUserToDialogs(_ values: NSSet)

}

// MARK: Generated accessors for userToServices
extension User {

    @objc(addUserToServicesObject:)
    @NSManaged public func addToUserToServices(_ value: Service)

    @objc(removeUserToServicesObject:)
    @NSManaged public func removeFromUserToServices(_ value: Service)

    @objc(addUserToServices:)
    @NSManaged public func addToUserToServices(_ values: NSSet)

    @objc(removeUserToServices:)
    @NSManaged public func removeFromUserToServices(_ values: NSSet)

}
