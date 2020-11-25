//
//  LyricsModel.swift
//  SyFLO
//
//  Created by 박성영 on 25/11/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation

struct LyricsModel {
    var time : Float?
    var lyric : String?
    
    init(_ time : Float, _ lyrics : String) {
        self.time = time
        self.lyric = lyrics
    }
}
