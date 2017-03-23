//
//  DownloadViewController.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-03-22.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {
    
    var homeViewController: ReloadTableProtocol!
    
    @IBOutlet weak var urlTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createCards(_ sender: UIButton) {
        let downloadManager = DownloadManager()
        downloadManager.makeCardsWithUrl(self.urlTextField.text ?? "", completion: {
            self.homeViewController.reloadTableView()
            let _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
}
