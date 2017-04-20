//
//  ResultsViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-04-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let scriptManager = ScriptManager.sharedInstance
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptManager.session.sortedDeck.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell", for: indexPath) as! ResultsTableViewCell
        cell.questionLabel.text = scriptManager.getQuestionForCardAtIndex(indexPath.row)
        cell.percentLabel.text = scriptManager.getSessionScoreForCardAtIndex(indexPath.row)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FullStatsPageViewController" {
            let fspvc = segue.destination as! FullStatsPageViewController
            fspvc.index = resultsTableView.indexPathForSelectedRow!.row
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "FullStatsPageViewController" {
            let index = resultsTableView.indexPathForSelectedRow!.row
            let cardIndex = Int(scriptManager.session.sortedDeck[index].index)
            if scriptManager.session.cardRecord.keys.contains(cardIndex) {
                return true
            }
            return false
        }
        return true
    }
}
