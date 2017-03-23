//
//  ScriptManager.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class ScriptManager: NSObject {
    struct SelectedScript {
        var scriptIndex = 0
        var characterIndex = 0
        var sectionIndex = 0
    }
    
    var selection = SelectedScript()
    static let sharedInstance = ScriptManager()
    private override init() {}
    let dataManager = DataManager.sharedInstance
    var scriptArray = [ScriptObject]()
    
    func fetchScripts() {
        scriptArray = dataManager.getScriptObjects()
    }
    
    func getCurrentScript() -> ScriptObject? {
        if selection.scriptIndex < scriptArray.count {
            return scriptArray[selection.scriptIndex]
        }
        return nil
    }
    
    func getCurrentCharacter() -> CharacterObject? {
        if let script = getCurrentScript() {
            let characterArray = script.characterObjectsArray()
            if selection.characterIndex < characterArray.count {
                return characterArray[selection.characterIndex]
            }
        }
        return nil
    }
    
    func getCurrentSection() -> SectionObject? {
        if let character = getCurrentCharacter() {
            let sectionArray = character.sectionObjectsArray()
            if selection.sectionIndex < sectionArray.count {
                return sectionArray[selection.sectionIndex]
            }
        }
        return nil
    }
    
    func getCharacters() -> [CharacterObject] {
        if let script = getCurrentScript() {
            return script.characterObjectsArray()
        }
        return [CharacterObject]()
    }
    
    func getSections() -> [SectionObject] {
        if let character = getCurrentCharacter() {
            return character.sectionObjectsArray()
        }
        return [SectionObject]()
    }
}
