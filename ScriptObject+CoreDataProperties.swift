//
//  ScriptObject+CoreDataProperties.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ScriptObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScriptObject> {
        return NSFetchRequest<ScriptObject>(entityName: "ScriptObject");
    }

    @NSManaged public var name: String?
    @NSManaged public var characters: NSOrderedSet?

}

// MARK: Generated accessors for characters
extension ScriptObject {

    @objc(insertObject:inCharactersAtIndex:)
    @NSManaged public func insertIntoCharacters(_ value: CharacterObject, at idx: Int)

    @objc(removeObjectFromCharactersAtIndex:)
    @NSManaged public func removeFromCharacters(at idx: Int)

    @objc(insertCharacters:atIndexes:)
    @NSManaged public func insertIntoCharacters(_ values: [CharacterObject], at indexes: NSIndexSet)

    @objc(removeCharactersAtIndexes:)
    @NSManaged public func removeFromCharacters(at indexes: NSIndexSet)

    @objc(replaceObjectInCharactersAtIndex:withObject:)
    @NSManaged public func replaceCharacters(at idx: Int, with value: CharacterObject)

    @objc(replaceCharactersAtIndexes:withCharacters:)
    @NSManaged public func replaceCharacters(at indexes: NSIndexSet, with values: [CharacterObject])

    @objc(addCharactersObject:)
    @NSManaged public func addToCharacters(_ value: CharacterObject)

    @objc(removeCharactersObject:)
    @NSManaged public func removeFromCharacters(_ value: CharacterObject)

    @objc(addCharacters:)
    @NSManaged public func addToCharacters(_ values: NSOrderedSet)

    @objc(removeCharacters:)
    @NSManaged public func removeFromCharacters(_ values: NSOrderedSet)

}
