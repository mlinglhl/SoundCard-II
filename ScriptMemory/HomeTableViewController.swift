//
//  HomeTableViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    struct CellHeight {
        var scriptHeight = 0
        var characterHeight = 0
        var sectionHeight = 0
    }
    
    let scriptDataSource = ScriptDataSource()
    let characterDataSource = CharacterDataSource()
    let sectionDataSource = SectionDataSource()
    let cellHeight = CellHeight()
    @IBOutlet weak var characterTableView: UITableView!
    @IBOutlet weak var scriptTableView: UITableView!
    @IBOutlet weak var sectionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scriptTableView.dataSource = scriptDataSource
        characterTableView.dataSource = characterDataSource
        sectionTableView.dataSource = sectionDataSource
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 0 {
            switch indexPath.section {
            case 0:
                return CGFloat(cellHeight.scriptHeight)
            case 1:
                return CGFloat(cellHeight.characterHeight)
            case 2:
                return CGFloat(cellHeight.sectionHeight)
            default:
                break
            }
        }
        return 25
    }
}
