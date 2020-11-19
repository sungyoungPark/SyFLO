//
//  LyricsTableViewCell.swift
//  SyFLO
//
//  Created by 박성영 on 20/11/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class LyricsTableViewCell: UITableViewCell {

    @IBOutlet var lyrics: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
