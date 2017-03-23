//
//  ScriptManager.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class ScriptManager: NSObject {
    
    //Tracks selections from the tableviews
    struct SelectedScript {
        var scriptIndex = 0
        var characterIndex = 0
        var sectionIndex = 0
    }
    
    //User settings
    struct UserSettings {
        var randomMode = false
        var weakCardsMoreFrequentMode = false
        var failedCardsAtEndMode = false
        var soundCueMode = false
    }
    
    //Tracks progress in the current session
    struct CardSession {
        var cardIndex = 0
        var numberCorrect = 0
        var numberWrong = 0
        var cardRecord = [Int: (Int, Int)]()
        var deck = [CardObject]()
        var extraCardCount = 0
        var extraCards = [CardObject]()
    }
    
    var selection = SelectedScript()
    var settings = UserSettings()
    var session = CardSession()
    static let sharedInstance = ScriptManager()
    private override init() {}
    let dataManager = DataManager.sharedInstance
    var scriptArray = [ScriptObject]()
    
    //Gets scripts from core data
    func fetchScripts() {
        scriptArray = dataManager.getScriptObjects()
    }
    
    //MARK: Helper Methods
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
    
    func getCards() -> [CardObject] {
        if let section = getCurrentSection() {
            return section.cardObjectsArray()
        }
        return [CardObject]()
    }
}

//MARK: Session extension
extension ScriptManager {
    func startSession() {
        session = CardSession()
        makeDeck()
    }
    
    func makeDeck() {
        session.cardIndex = 0
        var cards = getCards()
        if settings.randomMode {
            if settings.weakCardsMoreFrequentMode {
                for card in cards {
                    if card.rightCount + card.wrongCount > 0 {
                        let score = Double(card.rightCount)/Double(card.rightCount + card.wrongCount)
                        if score < 0.8 {
                            cards.append(card)
                            self.session.extraCardCount += 1
                            self.session.extraCards.append(card)
                        }
                        if score < 0.6 {
                            cards.append(card)
                            self.session.extraCardCount += 1
                            self.session.extraCards.append(card)
                        }
                        if score < 0.4 {
                            cards.append(card)
                            self.session.extraCardCount += 1
                            self.session.extraCards.append(card)
                        }
                        if score < 0.2 {
                            cards.append(card)
                            self.session.extraCardCount += 1
                            self.session.extraCards.append(card)
                        }
                    }
                }
                let end = cards.count
                var tempArray = [CardObject]()
                for _ in 0..<end {
                    let randomNumber = Int(arc4random_uniform(UInt32(cards.count)))
                    tempArray.append(cards[randomNumber])
                    cards.remove(at: randomNumber)
                }
                cards = tempArray
            }
        }
        session.deck = cards
    }
    
    func markCard(_ index: Int, isCorrect: Bool) {
        if !session.cardRecord.keys.contains(index) {
            session.cardRecord.updateValue((0, 0), forKey: index)
        }
        var correctAmount = session.cardRecord[index]!.0
        var wrongAmount = session.cardRecord[index]!.1
        let cards = session.deck
        if isCorrect {
            correctAmount += 1
            session.cardRecord.updateValue((correctAmount, wrongAmount), forKey: index)
            cards[session.cardIndex].rightCount += 1
            dataManager.saveContext()
            return
        }
        wrongAmount += 1
        session.cardRecord.updateValue((correctAmount, wrongAmount), forKey: index)
        cards[session.cardIndex].wrongCount += 1
        if settings.failedCardsAtEndMode {
            session.deck.append(cards[session.cardIndex])
            session.extraCardCount += 1
        }
        dataManager.saveContext()
    }
    
    //    func setUpCardFrontWithModifiedDeck(_ cardView: CardView) {
    //        let card = session.deck[session.cardIndex]
    //        cardView.questionSpeakerLabel.text = card.questionSpeaker ?? "No text"
    //        cardView.questionLabel.text = card.question ?? "No text"
    //        cardView.answerSpeakerLabel.text = card.answerSpeaker ?? "No text"
    //        cardView.answerLabel.text = card.answer ?? "No text"
    //    }
    //
    //    func setUpCardFrontWithUnmodifiedDeck(_ cardView: CardView) {
    //        guard let card = getCurrentCard() else {
    //            return
    //        }
    //        cardView.questionSpeakerLabel.text = card.questionSpeaker ?? "No text"
    //        cardView.questionLabel.text = card.question ?? "No text"
    //        cardView.answerSpeakerLabel.text = card.answerSpeaker ?? "No text"
    //        cardView.answerLabel.text = card.answer ?? "No text"
    //    }
    //
    //    func getCurrentCardFromDeck() -> CardObject {
    //        let cards = session.deck
    //        return cards[session.cardIndex]
    //    }
    //
    //    func getCurrentCard() -> CardObject? {
    //        let cards = getCardArray()
    //        return cards?[session.cardIndex]
    //    }
    //
    func getScore() -> String {
        var correct = 0
        var wrong = 0
        for index in session.cardRecord {
            correct += index.value.0
            wrong += index.value.1
        }
        if correct + wrong > 0 {
            let score = correct * 100 / (correct + wrong)
            return "Score: \(score)%"
        }
        return "Score: No cards marked"
    }
    
    //    func getScriptArray() -> [ScriptObject]? {
    //        if activeArray.count < setIndex + 1 {
    //            return nil
    //        }
    //        return activeArray
    //    }
    //
    //    func getCategoryArray() -> [CategoryObject]? {
    //        let sets = getSetArray()
    //        guard let currentSets = sets else {
    //            return nil
    //        }
    //        let categories = currentSets[setIndex].categoryObjectsArray()
    //        if categories.count < categoryIndex + 1 {
    //            return nil
    //        }
    //        return categories
    //    }
    //
    //    func getSectionArray() -> [SectionObject]? {
    //        let categories = getCategoryArray()
    //        guard let currentCategories = categories else {
    //            return nil
    //        }
    //        let sections = currentCategories[categoryIndex].sectionObjectsArray()
    //        if sections.count < sectionIndex + 1 {
    //            return nil
    //        }
    //        return sections
    //    }
    //
    //    func getCardArray() -> [CardObject]? {
    //        let sections = getSectionArray()
    //        guard let currentSections = sections else {
    //            return nil
    //        }
    //        let cards = currentSections[sectionIndex].cardObjectsArray()
    //        if cards.count < 1 {
    //            return nil
    //        }
    //        return cards
    //    }
    //
    func resetDeck() {
        session.cardIndex = 0
    }
    
    func getSessionResults() -> [Int] {
        return (session.cardRecord.keys).sorted()
    }
    
    func checkLast() -> Bool {
        let cards = session.deck
        if session.cardIndex == cards.count - 1 {
            return true
        }
        return false
    }
    
//    func nextCardSameLine() -> Bool {
//        let cards = session.deck
//        let card = cards[session.cardIndex]
//        return card.sameLine
//    }
}

