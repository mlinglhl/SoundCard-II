//
//  DownloadManager.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-22.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit
import CoreData

class DownloadManager: NSObject {
    
    struct Card {
        let question: String
        let answer: String
        let section: String
        let characterIndex: Int
        let questionSpeaker: String
        let answerSpeaker: String
        let index: Int
        
        init(question: String, answer: String, section: String, characterIndex: Int, questionSpeaker: String, answerSpeaker: String, index: Int) {
            self.question = question
            self.answer = answer
            self.section = section
            self.characterIndex = characterIndex
            self.questionSpeaker = questionSpeaker
            self.answerSpeaker = answerSpeaker
            self.index = index
        }
    }
    
    struct CardCharacter {
        var name: String
        var sections = [CardSection]()
        var currentSection = ""
        var sectionIndex = 0
        
        init(name: String) {
            self.name = name
        }
    }
    
    struct CardSection {
        var name: String
        var cards = [Card]()
        
        init(name: String) {
            self.name = name
        }
    }
    
    let dataManager = DataManager.sharedInstance
    var cardArray = [Card]()
    var cardHolder = Card(question: "", answer: "", section: "", characterIndex: 0, questionSpeaker: "", answerSpeaker: "", index: 9999)
    var previousCard = Card(question: "", answer: "Scene start", section: "", characterIndex: 0, questionSpeaker: "", answerSpeaker: "", index: 9999)
    var scriptName = ""
    var scriptType = ""
    var categories = NSMutableOrderedSet()
    var characterArray = [CardCharacter]()
    var cardIndex = 0
    var previousAnswer: String?
    
    func makeCardsWithUrl(_ urlString: String, completion: @escaping () -> Void) {
        
        let url = URL(string: urlString)
        guard let inputURL = url else {
            return
        }
        let task = URLSession.shared.dataTask(with: inputURL) { (data, response, error) in
            guard let data = data else {
                print ("No data returned from server \(error?.localizedDescription)")
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as! Array<Dictionary<String, String>> else {
                print("data returned is not json, or not valid")
                return
            }
            for dict in json {
                if self.scriptName == "" {
                    self.scriptName = dict["Name"] ?? ""
                }
                var dictCharacter = dict["Character"] ?? ""
                let answer = dict["Line"] ?? ""
                var section = dict["Section"] ?? ""
                if section == "" {
                    section = self.previousCard.section
                }
                if section != self.previousCard.section {
                    self.previousCard = Card(question: "", answer: "Scene start", section: "", characterIndex: 0, questionSpeaker: "", answerSpeaker: "", index: 9999)
                }
                    if dictCharacter == "" {
                        dictCharacter = self.previousCard.answerSpeaker
                    }
                    let whiteSpaceReducedDictCharacter = dictCharacter.replacingOccurrences(of: ", ", with: ",")
                    let tempCharacterArray = whiteSpaceReducedDictCharacter.components(separatedBy: ",")
                    for character in tempCharacterArray {
                        if !self.categories.contains(character){
                            self.categories.add(character)
                            self.characterArray.append(CardCharacter(name: character))
                        }
                        let characterIndex = self.categories.index(of: character)
                        let card = Card(question: self.previousCard.answer, answer: answer, section: section, characterIndex: characterIndex, questionSpeaker: self.previousCard.answerSpeaker, answerSpeaker: dictCharacter, index: self.cardIndex)
                        self.cardIndex += 1
                        self.cardArray.append(card)
                        self.cardHolder = card
                    }
                self.previousCard = self.cardHolder
            }
            self.makeCards()
            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
    
    func makeCards() {
        let script = dataManager.generateScriptObject()
        
        script.name = self.scriptName
        
        for card in cardArray {
            var character = characterArray[card.characterIndex]
            if (character.currentSection != card.section) {
                character.sections.append(CardSection(name: card.section))
                character.currentSection = card.section
                character.sectionIndex = character.sections.count - 1
            }
            character.sections[character.sectionIndex].cards.append(card)
            characterArray[card.characterIndex] = character
        }
        
        for character in characterArray {
            let characterObject = dataManager.generateCharacterObject()
            script.addToCharacters(characterObject)
            characterObject.name = character.name
            for section in character.sections {
                self.previousAnswer = nil
                let sectionObject = dataManager.generateSectionObject()
                characterObject.addToSections(sectionObject)
                sectionObject.name = section.name
                for card in section.cards {
                    let cardObject = dataManager.generateCardObject()
                    sectionObject.addToCards(cardObject)
                    cardObject.question = card.question
                    cardObject.answer = card.answer
                    cardObject.questionSpeaker = card.questionSpeaker
                    cardObject.answerSpeaker = card.answerSpeaker
                    cardObject.index = Int16(card.index)
                    previousAnswer = cardObject.answer
                }
            }
        }
        dataManager.saveContext()
    }
}
