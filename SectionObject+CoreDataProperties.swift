//
//  SectionObject+CoreDataProperties.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SectionObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SectionObject> {
        return NSFetchRequest<SectionObject>(entityName: "SectionObject");
    }

    @NSManaged public var name: String?
    @NSManaged public var character: CharacterObject?
    @NSManaged public var cards: NSOrderedSet?

}

// MARK: Generated accessors for cards
extension SectionObject {

    @objc(insertObject:inCardsAtIndex:)
    @NSManaged public func insertIntoCards(_ value: CardObject, at idx: Int)

    @objc(removeObjectFromCardsAtIndex:)
    @NSManaged public func removeFromCards(at idx: Int)

    @objc(insertCards:atIndexes:)
    @NSManaged public func insertIntoCards(_ values: [CardObject], at indexes: NSIndexSet)

    @objc(removeCardsAtIndexes:)
    @NSManaged public func removeFromCards(at indexes: NSIndexSet)

    @objc(replaceObjectInCardsAtIndex:withObject:)
    @NSManaged public func replaceCards(at idx: Int, with value: CardObject)

    @objc(replaceCardsAtIndexes:withCards:)
    @NSManaged public func replaceCards(at indexes: NSIndexSet, with values: [CardObject])

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CardObject)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CardObject)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSOrderedSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSOrderedSet)

}
