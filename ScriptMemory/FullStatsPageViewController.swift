//
//  FullStatsPageViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-04-19.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class FullStatsPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var viewControllerArray = [UIViewController]()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        dataSource = self
        setViewControllers([viewControllerArray[0]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    func setUp() {
        let scriptManager = ScriptManager.sharedInstance
        let card = scriptManager.session.sortedDeck[index]
        let cardIndex = Int(card.index)
        let question = card.question ?? "No question found"
        let recordArray = scriptManager.session.cardRecord[cardIndex]
        guard let records = recordArray else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        for index in 0..<records.count{
            let scvc = storyboard?.instantiateViewController(withIdentifier: "SingleCardViewController") as! SingleCardViewController
            scvc.cardData.question = question
            scvc.cardData.questionSpeaker = card.questionSpeaker ?? ""
            scvc.cardData.answer = records[index].answer
            scvc.cardData.enteredAnswer = records[index].enteredAnswer
            viewControllerArray.append(scvc)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerArray.index(of: viewController) else {
            return nil
        }
        
        let previousPage = index - 1
        
        if previousPage < 0 {
            return nil
        }
        
        if previousPage > viewControllerArray.count - 1 {
            return nil
        }
        
        return viewControllerArray[previousPage]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerArray.index(of: viewController) else {
            return nil
        }
        
        let nextPage = index + 1
        
        if nextPage < 0 {
            return nil
        }
        
        if nextPage > viewControllerArray.count - 1 {
            return nil
        }
        
        return viewControllerArray[nextPage]
    }

}
