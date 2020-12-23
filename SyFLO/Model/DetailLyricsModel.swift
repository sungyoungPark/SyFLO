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
    
    var progressTimer : Timer! // 타이머를 위한 변수
    //let timePlayerSelector:Selector = #selector(setCurrentPlayTime)
    var currentPlayTime = Dynamic(String())  //현재 실행중인 노래의 시간
    
    var player:AVPlayer? {
        didSet{
            if player?.currentItem?.status == .failed {
                print("음악 URL Error")
            }
        }
    }
    
    var playerItem:AVPlayerItem?
    
    var endTimePoint = Float()
    var playPoint = Dynamic(Float())  //seekBar에서 현재 진행중인 위치
    var lyrics_List : [LyricsModel]? //가사 시간과 가사가 들어가 있는 리스트
    var show_lyricIndex = Dynamic(Int())
    var isLastLyric = Dynamic(false)
    var isFirstLyric = Dynamic(false)

    
}


