//
//  MemoryViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-22.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class MemoryViewController: UIViewController {
    
    @IBOutlet weak var acceptAnswerButton: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionSpeakerLabel: UILabel!
    @IBOutlet weak var questionScrollView: UIScrollView!
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerScrollView: UIScrollView!
    
    let scriptManager = ScriptManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scriptManager.startSession()
        updateLabels()
    }
    
    @IBAction func acceptAnswer(_ sender: UIButton) {
        scriptManager.session.cardIndex += 1
        updateLabels()
    }
    
    override func viewDidLayoutSubviews() {
        questionScrollView.contentSize = CGSize(width: questionLabel.frame.width, height: questionLabel.frame.height + 10)
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
