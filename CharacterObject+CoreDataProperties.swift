//
//  CharacterObject+CoreDataProperties.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CharacterObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterObject> {
        return NSFetchRequest<CharacterObject>(entityName: "CharacterObject");
    }

    @NSManaged public var name: String?
    @NSManaged public var script: ScriptObject?
    @NSManaged public var sections: NSOrderedSet?

}

// MARK: Generated accessors for sections
extension CharacterObject {

    @objc(insertObject:inSectionsAtIndex:)
    @NSManaged public func insertIntoSections(_ value: SectionObject, at idx: Int)

    @objc(removeObjectFromSectionsAtIndex:)
    @NSManaged public func removeFromSections(at idx: Int)

    @objc(insertSections:atIndexes:)
    @NSManaged public func insertIntoSections(_ values: [SectionObject], at indexes: NSIndexSet)

    @objc(removeSectionsAtIndexes:)
    @NSManaged public func removeFromSections(at indexes: NSIndexSet)

    @objc(replaceObjectInSectionsAtIndex:withObject:)
    @NSManaged public func replaceSections(at idx: Int, with value: SectionObject)

    @objc(replaceSectionsAtIndexes:withSections:)
    @NSManaged public func replaceSections(at indexes: NSIndexSet, with values: [SectionObject])

    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: SectionObject)

    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: SectionObject)

    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSOrderedSet)

    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSOrderedSet)

}
