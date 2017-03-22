//
//  DataManager.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    static let sharedInstance = DataManager()
    private override init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ScriptMemory")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getScriptObjects() -> [ScriptObject] {
        let context = getContext()
        let request = NSFetchRequest<ScriptObject>(entityName: "ScriptObject")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        do {
            let scriptArray = try context.fetch(request)
            return scriptArray
        } catch {
            return [ScriptObject]()
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error \(nserror.localizedDescription)")
            }
        }
    }
    
    func generateScriptObject() -> ScriptObject {
        let scriptObject = NSEntityDescription.insertNewObject(forEntityName: "ScriptObject", into: self.getContext()) as! ScriptObject
        return scriptObject
    }
    
    func generateCharacterObject() -> CharacterObject {
        let characterObject = NSEntityDescription.insertNewObject(forEntityName: "CharacterObject", into: self.getContext()) as! CharacterObject
        return characterObject
    }
    
    func generateSectionObject() -> SectionObject {
        let sectionObject = NSEntityDescription.insertNewObject(forEntityName: "SectionObject", into: self.getContext()) as! SectionObject
        return sectionObject
    }
    
    func generateCardObject() -> CardObject{
        let cardObject = NSEntityDescription.insertNewObject(forEntityName: "CardObject", into: self.getContext()) as! CardObject
        return cardObject
    }
    
    func deleteObject(_ managedObject: NSManagedObject) {
        let context = getContext()
        context.delete(managedObject)
        saveContext()
    }
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
