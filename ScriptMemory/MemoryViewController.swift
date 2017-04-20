//
//  MemoryViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-22.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit
import Speech

class MemoryViewController: UIViewController, SFSpeechRecognizerDelegate, UIGestureRecognizerDelegate,  UITextViewDelegate {
    @IBOutlet weak var compareButton: UIButton!
    
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
    
    @IBOutlet var speechToTextTextViewTopAnchor: NSLayoutConstraint!
    var speechToTextTextViewTopAnchorKeyboardUp: NSLayoutConstraint!
    @IBOutlet var speechToTextTextViewBottomAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionSpeakerLabel: UILabel!
    @IBOutlet weak var questionScrollView: UIScrollView!
    
    let scriptManager = ScriptManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardResponse()
        setUpSession()
        setUpPushToTalk()
    }
    
    //MARK: SetUp Methods
    func setUpKeyboardResponse() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemoryViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemoryViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        speechToTextTextViewTopAnchorKeyboardUp = speechToTextTextView.topAnchor.constraint(equalTo: questionSpeakerLabel.topAnchor, constant: -8)
    }
    
    func setUpSession() {
        speechToTextTextView.delegate = self
        questionSpeakerLabel.text = "No question found"
        questionLabel.text = ""
        acceptAnswerButton.setTitle(" Check answer ", for: .normal)
        
        answerTextView.isHidden = true
        compareButton.isEnabled = false
        compareButton.alpha = 0.3
        currentProgressView.progress = 0.0
        
        scriptManager.startSession()
        updateLabels()
        
        checkForLastQuestion()
    }
    
    override func viewDidLayoutSubviews() {
        questionScrollView.contentSize = CGSize(width: questionLabel.frame.width, height: questionLabel.frame.height + 10)
        let buttonStart = acceptAnswerButton.frame.origin.x
        speechToTextLeadingAnchor.constant = buttonStart/2 - speechToTextButton.frame.width
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
    
    //MARK: Answering methods
    @IBAction func acceptAnswer(_ sender: UIButton) {
        if toggleButtonState() {
            setUpNextQuestion()
            return
        }
        submitAnswer()
    }
    
    func setUpNextQuestion() {
        speechToTextTextView.textColor = UIColor.black
        speechToTextTextView.text = ""
        answerTextView.isHidden = true
        speechToTextTextView.isEditable = true
        speechToTextButton.isEnabled = true
        speechToTextButton.alpha = 1
        compareButton.isEnabled = false
        compareButton.alpha = 0.3
        updateLabels()
    }
    
    func submitAnswer() {
        _ = endSpeechToText()
        checkAnswer()
        answerTextView.isHidden = false
        speechToTextTextView.isEditable = false
        speechToTextButton.isEnabled = false
        speechToTextButton.alpha = 0
        compareButton.isEnabled = true
        compareButton.alpha = 1
        scriptManager.session.cardIndex += 1
        updateProgressView()
        checkForLastQuestion()
    }
    
    func checkAnswer() {
        let enteredWords = speechToTextTextView.text
        let updatedStrings = scriptManager.checkRightWords(enteredWords ?? "")
        answerTextView.attributedText = updatedStrings[0]
        speechToTextTextView.attributedText = updatedStrings[1]
    }
    
    func toggleButtonState() -> Bool{
        if acceptAnswerButton.title(for: .normal) != " Next question " {
            acceptAnswerButton.setTitle(" Next question ", for: .normal)
            return false
        }
        acceptAnswerButton.setTitle(" Check answer ", for: .normal)
        return true
    }
    
    func updateProgressView() {
        currentProgressView.progress = Float(scriptManager.session.cardIndex) / Float(scriptManager.session.activeDeck.count)
    }
    
    func checkForLastQuestion() {
        if scriptManager.checkLast() {
            acceptAnswerButton.isEnabled = false
            acceptAnswerButton.alpha = 0.3
            speechToTextTextView.isEditable = false
        }
    }
    
    //MARK: Keyboard methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            _ = toggleButtonState()
            submitAnswer()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func dismissKeybord(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let height = keyboardFrame.height
        speechToTextTextViewTopAnchor.isActive = false
        speechToTextTextViewTopAnchorKeyboardUp.isActive = true
        speechToTextTextViewBottomAnchor.constant = height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        speechToTextTextViewTopAnchorKeyboardUp.isActive = false
        speechToTextTextViewTopAnchor.isActive = true
        speechToTextTextViewBottomAnchor.constant = 8
    }
    
    func updateLabels() {
        let deck = scriptManager.session.activeDeck
        let index = scriptManager.session.cardIndex
        if index < deck.count {
            questionSpeakerLabel.text = deck[index].questionSpeaker
            questionSpeakerLabelTopAnchor.constant = 8
            questionSpeakerHeightAnchor.constant = 21
            if questionSpeakerLabel.text == "" {
                questionSpeakerHeightAnchor.constant = 0
                questionSpeakerLabelTopAnchor.constant = 0
            }
            let question = deck[index].question ?? "No question found"
            let answer = deck[index].answer ?? "No answer found"
            let answerCount = answer.components(separatedBy: " ").count
            questionLabel.text = "\(question) (\(answerCount) words)"
            answerTextView.text = answer
        }
    }
    
    //MARK: SpeechToText methods
    @IBAction func toggleSpeechToText(_ sender: UIButton) {
        toggleSpeechToText()
    }
    
    func toggleSpeechToText() {
        if endSpeechToText() {
            speechToTextButton.alpha = 1
            return
        }
        speechToTextButton.alpha = 0.7
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
    
    //MARK: Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CompareViewController" {
            let cvc = segue.destination as! CompareViewController
            cvc.answerData.userInput = speechToTextTextView.attributedText
            cvc.answerData.answer = answerTextView.attributedText
        }
    }
}
