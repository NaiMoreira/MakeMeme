//
//  TableViewCell.swift
//  MakeMeme
//
//  Created by Nai on 16.03.20.
//  Copyright © 2020 Nai. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var memeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
