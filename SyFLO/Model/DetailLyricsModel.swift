//
//  DetailLyricsModel.swift
//  SyFLO
//
//  Created by 박성영 on 2020/12/14.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation
import AVFoundation

struct DetailLyricsModel{
    var player:AVPlayer? {
        didSet{
            if player?.currentItem?.status == .failed {
                print("음악 URL Error")
            }
        }
    }
    
    var playerItem:AVPlayerItem?
    
    var lyrics_List : [LyricsModel]? //가사 시간과 가사가 들어가 있는 리스트
    var show_lyricIndex = Dynamic(Int())
    var isLastLyric = Dynamic(false)
    var isFirstLyric = Dynamic(false)
}
    

