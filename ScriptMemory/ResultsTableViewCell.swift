//
//  ResultsTableViewCell.swift
//  ScriptMemory
//
//  Created by Minhung Ling on 2017-04-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
