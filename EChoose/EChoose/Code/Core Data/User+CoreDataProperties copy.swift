//
//  User+CoreDataProperties.swift
//  
//
//  Created by Oparin Oleg on 11.04.2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var profile: Profile?

}
