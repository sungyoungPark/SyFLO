//
//  DetailLyricsViewModel.swift
//  SyFLO
//
//  Created by 박성영 on 2020/12/14.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
import AVFoundation

class  DetailLyricsViewModel{
    
    //var detailLyricsModel = DetailLyricsModel()
    var musicPlayer = MusicPlayerModel()
    
    init() {
        
        print("DetailLyricsViewModel 생성")
        print(musicPlayer.playPoint.value)
    }
    
    func musicPlay(){
        musicPlayer.playMusic()
        print(musicPlayer.show_lyricIndex.value)
    }
    

      func seekMusic(_ sender: Float){
        musicPlayer.invalidatePlayer()//seekBar를 움직일때 재생바 움직임을 제어하기 위해
        musicPlayer.currentPlayTime.value = timetoString(time: TimeInterval(sender))
        musicPlayer.playPoint.value = sender
       
    }
    
    func moveToSeekTime(_ sender: Float){
        //CMTimeMake(value: Int64(sender.value), timescale: 1) CMTime 형식으로 변환
        musicPlayer.playPoint.value = Float(Int(sender))  //seekBar를 정확한 위치에 넣기위해 소수점을 제거하고 재생점 위치 시킴
        
        musicPlayer.moveToSeekTime(sender)
    }
    
    
}
