//
//  RootDataSource.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-23.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class RootDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var homeViewController: CollapseAllProtocol!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeViewController.collapseAll()
    }
}
