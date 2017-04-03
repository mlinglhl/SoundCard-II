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
        return scriptManager.getCards().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell", for: indexPath) as! ResultsTableViewCell
        cell.questionLabel.text = scriptManager.getQuestionForCardAtIndex(indexPath.row)
        cell.percentLabel.text = scriptManager.getSessionScoreForCardAtIndex(indexPath.row)
        return cell
    }
}
