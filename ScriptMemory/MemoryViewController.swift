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
    
    @IBOutlet weak var speechToTextButton: UIButton!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionSpeakerLabel: UILabel!
    @IBOutlet weak var questionScrollView: UIScrollView!
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerScrollView: UIScrollView!
    
    let scriptManager = ScriptManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scriptManager.startSession()
        currentProgressView.progress = 0.0
        updateLabels()
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
        acceptAnswerButton.setTitle(" Check answer ", for: .normal)
    }
    
    @IBAction func acceptAnswer(_ sender: UIButton) {
        scriptManager.session.cardIndex += 1
        currentProgressView.progress = Float(scriptManager.session.cardIndex) / Float(scriptManager.session.deck.count)
        updateLabels()
    }
    
    override func viewDidLayoutSubviews() {
        questionScrollView.contentSize = CGSize(width: questionLabel.frame.width, height: questionLabel.frame.height + 10)
        answerScrollView.contentSize = CGSize(width: answerLabel.frame.width, height: answerLabel.frame.height + 10)
    }
    
    @IBAction func toggleSpeechToText(_ sender: UIButton) {
    }
    func updateLabels() {
        let deck = scriptManager.session.deck
        let index = scriptManager.session.cardIndex
        if index < deck.count {
            questionSpeakerLabel.text = deck[index].questionSpeaker
            questionLabel.text = deck[index].question
            answerLabel.text = deck[index].answer
        }
    }
}
