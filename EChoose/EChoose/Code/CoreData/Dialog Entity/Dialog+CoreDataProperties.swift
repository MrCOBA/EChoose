//
//  Dialog+CoreDataProperties.swift
//  EChoose
//
//  Created by Oparin Oleg on 01.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//
//

import Foundation
import CoreData


extension Dialog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dialog> {
        return NSFetchRequest<Dialog>(entityName: "Dialog")
    }

    @NSManaged public var city: String?
    @NSManaged public var fullname: String?
    @NSManaged public var image: Data?
    @NSManaged public var isBotModeON: Bool
    @NSManaged public var username: String?
    @NSManaged public var dialogsToUser: User?
    @NSManaged public var dialogToMessages: NSOrderedSet?

}

// MARK: Generated accessors for dialogToMessages
extension Dialog {

    @objc(insertObject:inDialogToMessagesAtIndex:)
    @NSManaged public func insertIntoDialogToMessages(_ value: Message, at idx: Int)

    @objc(removeObjectFromDialogToMessagesAtIndex:)
    @NSManaged public func removeFromDialogToMessages(at idx: Int)

    @objc(insertDialogToMessages:atIndexes:)
    @NSManaged public func insertIntoDialogToMessages(_ values: [Message], at indexes: NSIndexSet)

    @objc(removeDialogToMessagesAtIndexes:)
    @NSManaged public func removeFromDialogToMessages(at indexes: NSIndexSet)

    @objc(replaceObjectInDialogToMessagesAtIndex:withObject:)
    @NSManaged public func replaceDialogToMessages(at idx: Int, with value: Message)

    @objc(replaceDialogToMessagesAtIndexes:withDialogToMessages:)
    @NSManaged public func replaceDialogToMessages(at indexes: NSIndexSet, with values: [Message])

    @objc(addDialogToMessagesObject:)
    @NSManaged public func addToDialogToMessages(_ value: Message)

    @objc(removeDialogToMessagesObject:)
    @NSManaged public func removeFromDialogToMessages(_ value: Message)

    @objc(addDialogToMessages:)
    @NSManaged public func addToDialogToMessages(_ values: NSOrderedSet)

    @objc(removeDialogToMessages:)
    @NSManaged public func removeFromDialogToMessages(_ values: NSOrderedSet)

}
