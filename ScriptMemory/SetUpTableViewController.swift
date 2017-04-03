//
//  SetUpTableViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-04-02.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class SetUpTableViewController: UITableViewController {
    
    @IBOutlet weak var randomOrderSwitch: UISwitch!
    @IBOutlet weak var increaseWeakFrequencySwitch: UISwitch!
    
    var increaseWeakFrequencyCellHeight = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomOrderSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        increaseWeakFrequencySwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return increaseWeakFrequencyCellHeight
        }
        return 25
    }
    
    @IBAction func randomSwitchToggled(_ sender: UISwitch) {
        tableView.beginUpdates()
        increaseWeakFrequencyCellHeight = toggleCellHeight()
        tableView.endUpdates()
        if increaseWeakFrequencyCellHeight == CGFloat(0) {
            increaseWeakFrequencySwitch.isOn = false
        }
    }
    
    func toggleCellHeight() -> CGFloat {
        return increaseWeakFrequencyCellHeight == CGFloat(25) ? CGFloat(0) : CGFloat(25)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let scriptManager = ScriptManager.sharedInstance
        scriptManager.settings.randomMode = randomOrderSwitch.isOn
        scriptManager.settings.weakCardsMoreFrequentMode = increaseWeakFrequencySwitch.isOn
        _ = navigationController?.popViewController(animated: true)
    }
}
