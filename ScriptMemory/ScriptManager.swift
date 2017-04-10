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
        var increaseWeakFrequency = false
        var fullScriptMode = false
    }
    
    //Tracks progress in the current session
    struct CardSession {
        var cardIndex = 0
        var numberCorrect = 0
        var numberWrong = 0
        var cardRecord = [Int: [CardAttempt]]()
        var deck = [CardObject]()
        var extraCardCount = 0
        var extraCards = [CardObject]()
    }
    
    struct CardAttempt {
        var rightCount = 0
        var wrongCount = 0
        var answer = NSAttributedString(string: "")
        var enteredAnswer = NSAttributedString(string: "")
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
        if settings.fullScriptMode {
            let character = getCurrentCharacter()
            if let character = character {
                let sections = character.sectionObjectsArray()
                for section in sections {
                    let sectionCards = section.cardObjectsArray()
                    for card in sectionCards {
                        cards.append(card)
                    }
                }
            }
        }
        if settings.randomMode {
            if settings.increaseWeakFrequency {
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
        session.deck = cards
    }
    
    func checkRightWords(_ enteredWords: String) -> [NSAttributedString] {
        var answer = session.deck[session.cardIndex].answer
        let answerArray = answer!.components(separatedBy: " ")
        let enteredWordsArray = enteredWords.components(separatedBy: " ")
        var rightAnswerDictionary = Dictionary<Int, Int>()
        var rightEnteredDictionary = Dictionary<Int, Int>()
        for index in 0...answerArray.count {
            if answerArray.count > index && enteredWordsArray.count > index {
                if answerArray[index].lowercased() == enteredWordsArray[index].lowercased() {
                    var answerRangeStart = 0
                    var enteredRangeStart = 0
                    if index > 0 {
                        for rangeIndex in 0..<index {
                            answerRangeStart += answerArray[rangeIndex].characters.count + 1
                            enteredRangeStart += enteredWordsArray[rangeIndex].characters.count + 1
                        }
                    }
                    let answerLength = answerArray[index].characters.count
                    let enteredLength = enteredWordsArray[index].characters.count
                    rightAnswerDictionary.updateValue(answerLength, forKey: answerRangeStart)
                    rightEnteredDictionary.updateValue(enteredLength, forKey: enteredRangeStart)
                }
            }
        }
        
        let defaultAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 17),
            NSForegroundColorAttributeName: UIColor.red
        ]
        
        let answerString = NSMutableAttributedString(string: answer! as String)
        answerString.addAttributes(defaultAttributes, range: NSRange(location: 0, length: answer!.characters.count))
        let enteredString = NSMutableAttributedString(string: enteredWords as String)
        enteredString.addAttributes(defaultAttributes, range: NSRange(location: 0, length: enteredWords.characters.count))
        
        for key in rightAnswerDictionary.keys {
            answerString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:key,length:rightAnswerDictionary[key]!))
        }
        
        for key in rightEnteredDictionary.keys {
            enteredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:key,length:rightEnteredDictionary[key]!))
        }
        
        markCard(rightCount: rightEnteredDictionary.keys.count, totalEnteredLength: enteredWordsArray.count, totalAnswerLength: answerArray.count, answer: answerString, enteredAnswer: enteredString)
        
        return [answerString, enteredString]
    }
    
    func markCard(rightCount: Int, totalEnteredLength: Int, totalAnswerLength: Int, answer: NSAttributedString, enteredAnswer: NSAttributedString) {
        let card = session.deck[session.cardIndex]
        let index = Int(card.index)
        var wrongCount = totalEnteredLength
        if wrongCount < totalAnswerLength {
            wrongCount = totalAnswerLength
        }
        
        wrongCount -= rightCount
        
        card.rightCount += rightCount
        card.wrongCount += wrongCount
        dataManager.saveContext()
        var cardAttempt = CardAttempt()
        cardAttempt.rightCount = rightCount
        cardAttempt.wrongCount = wrongCount
        cardAttempt.answer = answer
        cardAttempt.enteredAnswer = enteredAnswer
        if !session.cardRecord.keys.contains(index) {
            session.cardRecord.updateValue([CardAttempt](), forKey: index)
        }
        var cardAttemptArray = session.cardRecord[index]!
        cardAttemptArray.append(cardAttempt)
        session.cardRecord.updateValue(cardAttemptArray, forKey: index)
    }
    
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
}

//MARK: Results extension
extension ScriptManager {
    func getQuestionForCardAtIndex(_ index: Int) -> String {
        return getCards()[index].question ?? "No question found"
    }
    
    func getSessionScoreForCardAtIndex(_ index: Int) -> String {
        let cardIndex = Int(getCards()[index].index)
        let attemptArray = session.cardRecord[cardIndex]
        guard let unwrappedAttemptArray = attemptArray else {
            return "Not done"
        }
        var rightCount = 0
        var wrongCount = 0
        for attempt in unwrappedAttemptArray {
            rightCount += attempt.rightCount
            wrongCount += attempt.wrongCount
        }
        let score = rightCount * 100 / (rightCount + wrongCount)
        return "\(score)%"
    }
}
