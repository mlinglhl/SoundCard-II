//
//  SingleCardViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-04-19.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class SingleCardViewController: UIViewController {
    
    struct CardData {
        var questionSpeaker = ""
        var question = "No question found"
        var enteredAnswer = NSAttributedString()
        var answer = NSAttributedString()
    }

    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var enteredAnswerView: UIView!

    @IBOutlet weak var questionSpeakerLabel: UILabel!
    @IBOutlet weak var questionSpeakerLabelHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var questionSpeakerLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionScrollView: UIScrollView!
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerScrollView: UIScrollView!
    
    @IBOutlet weak var enteredAnswerLabel: UILabel!
    @IBOutlet weak var enteredAnswerScrollView: UIScrollView!    
    
    var cardData = CardData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionSpeakerLabel.text = cardData.questionSpeaker
        if questionSpeakerLabel.text == "" {
            questionSpeakerLabelHeightAnchor.constant = 0
            questionSpeakerLabelTopAnchor.constant = 0
        }
        questionLabel.text = cardData.question
        answerLabel.attributedText = cardData.answer
        enteredAnswerLabel.attributedText = cardData.enteredAnswer
        questionView.layer.borderColor = UIColor.black.cgColor
        questionView.layer.borderWidth = 3
        answerView.layer.borderColor = UIColor.black.cgColor
        answerView.layer.borderWidth = 3
        enteredAnswerView.layer.borderColor = UIColor.black.cgColor
        enteredAnswerView.layer.borderWidth = 3
    }
    
    override func viewDidLayoutSubviews() {
        let questionWidth = questionSpeakerLabel.frame.width > questionLabel.frame.width ? questionSpeakerLabel.frame.width : questionLabel.frame.width
        let questionHeight = questionSpeakerLabel.frame.height + questionLabel.frame.height + 10
        questionScrollView.contentSize = CGSize(width: questionWidth, height: questionHeight)
        
        let answerWidth = answerLabel.frame.width
        let answerHeight = answerLabel.frame.height + 31
        answerScrollView.contentSize = CGSize(width: answerWidth, height: answerHeight)
        
        let enteredAnswerWidth = enteredAnswerLabel.frame.width
        let enteredAnswerHeight = enteredAnswerLabel.frame.height + 31
        enteredAnswerScrollView.contentSize = CGSize(width: enteredAnswerWidth, height: enteredAnswerHeight)
    }
}
