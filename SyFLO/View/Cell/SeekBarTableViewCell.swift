//
//  SeekBarTableViewCell.swift
//  SyFLO
//
//  Created by 박성영 on 20/11/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class SeekBarTableViewCell: UITableViewCell {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var seekBar: UIProgressView!
    @IBOutlet var duration: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("13")
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
