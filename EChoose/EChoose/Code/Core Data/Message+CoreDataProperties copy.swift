//
//  Message+CoreDataProperties.swift
//  
//
//  Created by Oparin Oleg on 09.04.2021.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isIncoming: Bool
    @NSManaged public var text: String?
    @NSManaged public var dialog: Dialog?

}
