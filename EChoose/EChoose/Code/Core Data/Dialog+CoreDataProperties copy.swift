//
//  Dialog+CoreDataProperties.swift
//  
//
//  Created by Oparin Oleg on 11.04.2021.
//
//

import Foundation
import CoreData


extension Dialog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dialog> {
        return NSFetchRequest<Dialog>(entityName: "Dialog")
    }

    @NSManaged public var id: Int32
    @NSManaged public var lastMessage: MessageDefault?
    @NSManaged public var user1: Int32
    @NSManaged public var user2: Int32
    @NSManaged public var messages: [MessageDefault]?
    @NSManaged public var profile: Profile?

}
