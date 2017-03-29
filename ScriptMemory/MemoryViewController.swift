//
//  MemoryViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-22.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit
import Speech

class MemoryViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var currentProgressView: UIProgressView!
    @IBOutlet weak var acceptAnswerButton: UIButton!
    
    @IBOutlet weak var speechToTextLeadingAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var questionSpeakerHeightAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var questionSpeakerLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var answerTextViewLeadingAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var speechToTextTextView: UITextView!
    @IBOutlet weak var speechToTextButton: UIButton!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionSpeakerLabel: UILabel!
    @IBOutlet weak var questionScrollView: UIScrollView!
    
    let scriptManager = ScriptManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    //MARK: SetUp Methods
    func setUp() {
        acceptAnswerButton.setTitle(" Check answer ", for: .normal)
        answerTextView.isHidden = true
        currentProgressView.progress = 0.0
        
        //sets push to talk button position
        let buttonStart = acceptAnswerButton.frame.origin.x
        speechToTextLeadingAnchor.constant = buttonStart/2 - speechToTextButton.frame.width/2
        
        scriptManager.startSession()
        updateLabels()
        
        setUpPushToTalk()
        //        self.answerTextViewLeadingAnchor.constant = self.view.frame.width
    }
    
    func setUpPushToTalk() {
        speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            switch authStatus {
            case .authorized:
                break
            case .denied:
                print("User denied access to speech recognition")
                
            case .restricted:
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                print("Speech recognition not yet authorized")
            }
            OperationQueue.main.addOperation() {
            }
        }
    }
    
    @IBAction func acceptAnswer(_ sender: UIButton) {
        if toggleButtonState() {
            speechToTextTextView.text = ""
            answerTextView.isHidden = true
            speechToTextTextView.isEditable = true
            speechToTextButton.isEnabled = true
            nextQuestion()
            return
        }
        checkAnswer()
        answerTextView.isHidden = false
        speechToTextTextView.isEditable = false
        speechToTextButton.isEnabled = false
    }
    
    func checkAnswer() {
        let answer = scriptManager.session.deck[scriptManager.session.cardIndex].answer
        let enteredWords = speechToTextTextView.text
        let rightWords = checkRightWords()
        let defaultAttributes = [
            NSFontAttributeName: UIFont(name: "Arial", size: 17.0)!,
            NSForegroundColorAttributeName: UIColor.red
        ]
        let answerString = NSMutableAttributedString(string: answer! as String)
        answerString.addAttributes(defaultAttributes, range: NSRange(location: 0, length: answer!.characters.count))
//        answerString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 0, length: answer!.characters.count))
        let enteredString = NSMutableAttributedString(string: enteredWords! as String)
        enteredString.addAttributes(defaultAttributes, range: NSRange(location: 0, length: enteredWords!.characters.count))
//        enteredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 0, length: enteredWords!.characters.count))
       
        for key in rightWords[0].keys {
            answerString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:key,length:rightWords[0][key]!))
        }
        
        for key in rightWords[1].keys {
            enteredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:key,length:rightWords[1][key]!))
        }
        
        answerTextView.attributedText = answerString
        speechToTextTextView.attributedText = enteredString
    }
    
    func checkRightWords() -> [Dictionary <Int, Int>] {
        let enteredWords = speechToTextTextView.text
        let answer = scriptManager.session.deck[scriptManager.session.cardIndex].answer
        let answerArray = answer!.components(separatedBy: " ")
        let enteredWordsArray = enteredWords!.components(separatedBy: " ")
        var rightAnswerDictionary = Dictionary<Int, Int>()
        var rightEnteredDictionary = Dictionary<Int, Int>()
        for index in 0...answerArray.count {
            if enteredWordsArray.count > index {
                if answerArray[index] == enteredWordsArray[index] {
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
        return [rightAnswerDictionary, rightEnteredDictionary]
    }
    
    func toggleButtonState() -> Bool{
        if acceptAnswerButton.title(for: .normal) != " Next question " {
            acceptAnswerButton.setTitle(" Next question ", for: .normal)
            self.answerTextViewLeadingAnchor.constant = self.speechToTextTextView.frame.origin.x
            return false
        }
        acceptAnswerButton.setTitle(" Check answer ", for: .normal)
        return true
    }
    
    func nextQuestion() {
        answerTextViewLeadingAnchor.constant = self.view.frame.width
        scriptManager.session.cardIndex += 1
        currentProgressView.progress = Float(scriptManager.session.cardIndex) / Float(scriptManager.session.deck.count)
        updateLabels()
    }
    
    override func viewDidLayoutSubviews() {
        questionScrollView.contentSize = CGSize(width: questionLabel.frame.width, height: questionLabel.frame.height + 10)
    }
    
    @IBAction func dismissKeybord(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func updateLabels() {
        let deck = scriptManager.session.deck
        let index = scriptManager.session.cardIndex
        if index < deck.count {
            questionSpeakerLabel.text = deck[index].questionSpeaker
            questionSpeakerLabelTopAnchor.constant = 8
            questionSpeakerHeightAnchor.constant = 21
            if questionSpeakerLabel.text == "" {
                questionSpeakerHeightAnchor.constant = 0
                questionSpeakerLabelTopAnchor.constant = 0
            }
            questionLabel.text = deck[index].question
            answerTextView.text = deck[index].answer
        }
    }
    
    @IBAction func toggleSpeechToText(_ sender: UIButton) {
        toggleSpeechToText()
    }
    
    func toggleSpeechToText() {
        if endSpeechToText() {
            return
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.speechToTextTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func endSpeechToText() -> Bool {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
            return true
        }
        return false
    }
}
