//
//  Message+CoreDataProperties.swift
//  EChoose
//
//  Created by Oparin Oleg on 19.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
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

extension Message : Identifiable {

}
