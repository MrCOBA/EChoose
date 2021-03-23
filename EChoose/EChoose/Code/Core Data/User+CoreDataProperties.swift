//
//  User+CoreDataProperties.swift
//  EChoose
//
//  Created by Oparin Oleg on 19.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
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

extension User : Identifiable {

}
