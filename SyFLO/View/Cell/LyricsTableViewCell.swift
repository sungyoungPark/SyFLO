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
    var fontSize = 20
    
    func setAutoLayout(){
        // 사이즈가 텍스트에 맞게 조절.
        lyrics.sizeToFit()
        // 여러줄로 나눠질 때 워드 단위로 끊어지도록 설정.
        lyrics.lineBreakMode = .byWordWrapping
        // label이 여러줄을 가질 수 있도록 설정.
        lyrics.numberOfLines = 0
        lyrics.font = lyrics.font.withSize(CGFloat(fontSize))
    }
    
}
