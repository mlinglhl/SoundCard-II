//
//  ScriptDataSource.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class ScriptDataSource: RootDataSource {

    var scriptArray = [ScriptObject]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = scriptArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scriptManager = ScriptManager.sharedInstance
        scriptManager.selection.scriptIndex = indexPath.row
        scriptManager.selection.characterIndex = 0
        scriptManager.selection.sectionIndex = 0
        homeViewController.updateCharacterDataSource()
        homeViewController.updateSectionDataSource()
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}
