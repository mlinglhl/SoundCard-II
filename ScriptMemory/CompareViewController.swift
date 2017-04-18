//
//  CompareViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-30.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController, UIGestureRecognizerDelegate {
    
    struct AnswerData {
        var userInput = NSAttributedString()
        var answer = NSAttributedString()
    }

    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    var answerData = AnswerData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerTextView.attributedText = answerData.answer
        answerTextView.layer.borderColor = UIColor.black.cgColor
        answerTextView.layer.borderWidth = 3
        userInputTextView.attributedText = answerData.userInput
        userInputTextView.layer.borderColor = UIColor.black.cgColor
        userInputTextView.layer.borderWidth = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapGesturePressed(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
