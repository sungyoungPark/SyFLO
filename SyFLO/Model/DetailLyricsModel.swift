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
    
    func controlMusic(){
        //player.rate = 재생속도를 의미함
        //print(player?.currentItem?.duration.seconds)  //노래 전체 시간 (duration)
        //print(player?.currentItem?.currentTime().seconds) //노래 진행 시간
        if(player?.rate == 0){
            player?.play()
        }
        else{
            player?.pause()
        }
    }
    
    
 
    
    
    
}


