//
//  TableViewCell.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/23.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var sheetLabel: UILabel!
    
    @IBOutlet weak var sheetWord: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
