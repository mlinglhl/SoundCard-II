//
//  CardObject+CoreDataProperties.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-22.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CardObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardObject> {
        return NSFetchRequest<CardObject>(entityName: "CardObject");
    }

    @NSManaged public var answer: String?
    @NSManaged public var answerSpeaker: String?
    @NSManaged public var question: String?
    @NSManaged public var questionSpeaker: String?
    @NSManaged public var rightCount: Int16
    @NSManaged public var wrongCount: Int16
    @NSManaged public var index: Int16
    @NSManaged public var section: SectionObject?

}
