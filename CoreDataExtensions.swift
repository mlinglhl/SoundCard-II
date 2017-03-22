
//
//  CoreDataExtensions.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

extension ScriptObject {
    func CharacterObjectsArray() -> [CharacterObject] {
        let ordered = self.characters
        let anyArray = ordered?.array
        if let castCategory = anyArray as? [CharacterObject] {
            return castCategory
        }
        return [CharacterObject]()
    }
}

extension CharacterObject {
    func sectionObjectsArray() -> [SectionObject] {
        let ordered = self.sections
        let anyArray = ordered?.array
        if let castSection = anyArray as? [SectionObject] {
            return castSection
        }
        return [SectionObject]()
    }
}

extension SectionObject {
    func cardObjectsArray() -> [CardObject] {
        let ordered = self.cards
        let anyArray = ordered?.array
        if let castCategory = anyArray as? [CardObject] {
            return castCategory
        }
        return [CardObject]()
    }
}
