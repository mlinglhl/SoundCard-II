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
            nextQuestion()
        }
        checkAnswer()
        answerTextView.isHidden = false
    }
    
    func checkAnswer() {
        let answer = scriptManager.session.deck[scriptManager.session.cardIndex].answer
        let rightWords = checkRightWords()
        let answerString = NSMutableAttributedString(string: answer! as String)
        answerString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 0, length: answer!.characters.count))
        for key in rightWords.keys {
            answerString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:key,length:rightWords[key]!))
        }
        answerTextView.attributedText = answerString
    }
    
    func checkRightWords() -> Dictionary <Int, Int> {
        let enteredWords = speechToTextTextView.text
        let answer = scriptManager.session.deck[scriptManager.session.cardIndex].answer
        let answerArray = answer!.components(separatedBy: " ")
        let enteredWordsArray = enteredWords!.components(separatedBy: " ")
        var rightDictionary = Dictionary<Int, Int>()
        for index in 0...answerArray.count {
            if enteredWordsArray.count > index {
                if answerArray[index] == enteredWordsArray[index] {
                    var rangeStart = 0
                    if index > 0 {
                        for rangeIndex in 0..<index {
                            rangeStart += answerArray[rangeIndex].characters.count + 1
                        }
                    }
                    let length = answerArray[index].characters.count
                    rightDictionary.updateValue(length, forKey: rangeStart)
                }
            }
        }
        return rightDictionary
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
