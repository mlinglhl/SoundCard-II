//
//  HomeTableViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

protocol ReloadTableProtocol {
    func reloadTableView()
}

protocol UpdateDataProtocol {
    func updateCharacterDataSource()
    func updateSectionDataSource()
    func collapseAll()
}

class HomeTableViewController: UITableViewController, ReloadTableProtocol, UpdateDataProtocol {
    struct CellHeight {
        var scriptHeight = 0
        var characterHeight = 0
        var sectionHeight = 0
    }
    
    
    @IBOutlet weak var selectedScriptLabel: UILabel!
    @IBOutlet weak var selectedCharacterLabel: UILabel!
    @IBOutlet weak var selectedSectionLabel: UILabel!
    
    let defaultCellHeight = 25
    let scriptManager = ScriptManager.sharedInstance
    let scriptDataSource = ScriptDataSource()
    let characterDataSource = CharacterDataSource()
    let sectionDataSource = SectionDataSource()
    var cellHeight = CellHeight()
    @IBOutlet weak var characterTableView: UITableView!
    @IBOutlet weak var scriptTableView: UITableView!
    @IBOutlet weak var sectionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDataSources()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        switch indexPath.section {
        case 0:
            let height = cellHeight.scriptHeight
            cellHeight.scriptHeight = adjustHeight(height, count: scriptDataSource.scriptArray.count)
            break
        case 1:
            let height = cellHeight.characterHeight
            cellHeight.characterHeight = adjustHeight(height, count: characterDataSource.characterArray.count)
            break
        case 2:
            let height = cellHeight.sectionHeight
            cellHeight.sectionHeight = adjustHeight(height, count: sectionDataSource.sectionArray.count)
            break
        default:
            break
        }
        tableView.endUpdates()
    }
    
    func adjustHeight (_ height: Int, count: Int) -> Int {
        let newHeight = defaultCellHeight * count
        return height == newHeight ? 0 : newHeight
    }
    
    func collapseAll() {
        tableView.beginUpdates()
        updateSectionTitles()
        cellHeight.scriptHeight = 0
        cellHeight.characterHeight = 0
        cellHeight.sectionHeight = 0
        tableView.endUpdates()
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
        if indexPath.row == 0 {
            switch indexPath.section {
            case 0:
                let height = cellHeight.scriptHeight > 0 ? 0 : defaultCellHeight
                return CGFloat(height)
            case 1:
                let height = cellHeight.characterHeight > 0 ? 0 : defaultCellHeight
                return CGFloat(height)
            case 2:
                let height = cellHeight.sectionHeight > 0 ? 0 : defaultCellHeight
                return CGFloat(height)
            default:
                break
            }
        }
        return CGFloat(defaultCellHeight)
    }
    
    func reloadTableView() {
        scriptManager.fetchScripts()
        updateDataSource()
        updateSectionTitles()
        tableView.reloadData()
    }
    
    func setUpDataSources() {
        scriptTableView.dataSource = scriptDataSource
        scriptTableView.delegate = scriptDataSource
        scriptDataSource.homeViewController = self
        characterTableView.dataSource = characterDataSource
        characterTableView.delegate = characterDataSource
        characterDataSource.homeViewController = self
        sectionTableView.dataSource = sectionDataSource
        sectionTableView.delegate = sectionDataSource
        sectionDataSource.homeViewController = self
        scriptManager.fetchScripts()
        updateDataSource()
        updateSectionTitles()
    }
    
    func updateDataSource() {
        scriptDataSource.scriptArray = scriptManager.scriptArray
        scriptTableView.reloadData()
        if scriptManager.scriptArray.count > 0 {
            scriptTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        }
        updateCharacterDataSource()
        updateSectionDataSource()
    }
    
    func updateCharacterDataSource() {
        characterDataSource.characterArray = scriptManager.getCharacters()
        characterTableView.reloadData()
        
        guard let script = scriptManager.getCurrentScript() else {
            return
        }
        
        if script.characterObjectsArray().count > 0 {
            characterTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        }
        updateSectionDataSource()
    }
    
    func updateSectionDataSource() {
        sectionDataSource.sectionArray = scriptManager.getSections()
        sectionTableView.reloadData()
        
        guard let character = scriptManager.getCurrentCharacter() else {
            return
        }
        
        if character.sectionObjectsArray().count > 0 {
            sectionTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        }
    }
    
    func updateSectionTitles() {
        selectedScriptLabel.text = "No scripts found"
        selectedCharacterLabel.text = "No characters found"
        selectedSectionLabel.text = "No sections found"
        
        if let script = scriptManager.getCurrentScript() {
            selectedScriptLabel.text = script.name
        }
        
        if let character = scriptManager.getCurrentCharacter() {
            selectedCharacterLabel.text = character.name
        }
        
        if let section = scriptManager.getCurrentSection() {
            selectedSectionLabel.text = section.name
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DownloadViewController" {
            let dvc = segue.destination as! DownloadViewController
            dvc.homeViewController = self
        }
    }
    
    func customSnapshotFromView(inputView: UIView) -> UIView {
        
        // Make an image from the input view.
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        // Create an image view.
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        
        return snapshot
    }
}
