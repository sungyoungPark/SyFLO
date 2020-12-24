//
//  MusicPlayerModel.swift
//  SyFLO
//
//  Created by 박성영 on 2020/12/14.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerModel {
    var progressTimer : Timer! // 타이머를 위한 변수
    let timePlayerSelector:Selector = #selector(setCurrentPlayTime)
    
    var currentPlayTime = Dynamic(String())  //현재 실행중인 노래의 시간
    var endTimePoint = Float()  //노래의 길이, 끝나는 시간
    var playPoint = Dynamic(Float())  //seekBar에서 현재 진행중인 위치
    var lyrics_List : [LyricsModel]? //가사 시간과 가사가 들어가 있는 리스트
    
    var show_lyricIndex = Dynamic(Int())
    var isLastLyric = Dynamic(false)
    var isFirstLyric = Dynamic(false)
    var isPlaying = Dynamic(false)
    
    
    
    var player:AVPlayer? {
        didSet{
            if player?.currentItem?.status == .failed {
                print("음악 URL Error")
            }
        }
    }
    var playerItem:AVPlayerItem?
    
    func setLyricsList(_ lyrics : String){
        lyrics_List = lyrics.replacingOccurrences(of: "[", with: "").components(separatedBy: "\n").map { (sub) -> LyricsModel in
            let str2 = sub.components(separatedBy: "]")
            let time = str2[0].components(separatedBy: ":")
            return LyricsModel(Float(Int(time[0])! * 60 + Int(time[1])!) + Float(Double(time[2])! * 0.001)
                , str2[1])
        }
    }
    
    
    func setPlayer(){
        player = AVPlayer(playerItem: playerItem)
    }
    
    func playMusic(){
        //player.rate = 재생속도를 의미함
        //print(player?.currentItem?.duration.seconds)  //노래 전체 시간 (duration)
        //print(player?.currentItem?.currentTime().seconds) //노래 진행 시간
        if(player?.rate == 0){
            
            if(playPoint.value >= endTimePoint){ //음악이 끝나면 다시 처음부터 재생
                player?.seek(to: .zero) // 음악 재생위치를 처음으로 되돌림
            }
            
            player?.play()
            if(progressTimer == nil){
                //print("progreesTimer nil")
                progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
            }
        }
        else{
            player?.pause()
        }
    }
    
    func invalidatePlayer(){
        if(progressTimer != nil){
            progressTimer.invalidate() //seekBar를 움직일때 재생바 움직임을 제어하기 위해
        }
    }
    
    func moveToSeekTime(_ sender: Float){
        
        //CMTimeMake(value: Int64(sender.value), timescale: 1) CMTime 형식으로 변환
        
        player?.seek(to: CMTimeMake(value: Int64(sender), timescale: 1)) // seekBar 위치로 노래 이동
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)  //seekMusic에서 invalidate한 것을 다시 시작
        
    }
    
    @objc func setCurrentPlayTime() {   //현재 재생시간과 가사 뷰에 보여지는 가사를 설정하는 함수
        currentPlayTime.value = timeString(time: TimeInterval((player?.currentItem?.currentTime().seconds)!))
        playPoint.value = Float((player?.currentItem?.currentTime().seconds)!)
        
        if(playPoint.value < (lyrics_List!.first?.time!)!){  //노래가 시작하고 처음 가사 시작점보다 현재 재생위치가 작을때
            //가사 보여주는 테이블에 첫번째 cell에 색을 빼주기 위함
            if(isFirstLyric.value == true){
                isFirstLyric.value = false
            }
            if(isLastLyric.value == true){
                isLastLyric.value = false
            }
            if(show_lyricIndex.value != 0 ){
                show_lyricIndex.value = 0
            }
            return
        }
        else{
            if(isFirstLyric.value == false){
                isFirstLyric.value = true   //노래 재생 시간이 처음가사 시간을 넘기면
            }
        }
        
        while true {
            if(show_lyricIndex.value == lyrics_List!.count - 1){  //노래의 마지막 가사를 가르킬때
                if(isLastLyric.value == false){
                    isLastLyric.value = true   //가사 보여주는 테이블뷰에 두번째 cell에 색을 넣기 위함
                }
                show_lyricIndex.value -= 1
                break
            }
            
            
            if( playPoint.value <= lyrics_List![show_lyricIndex.value+1].time! && playPoint.value > lyrics_List![show_lyricIndex.value].time!){   //노래가 현재 가사 시간에 있을때
                if(isLastLyric.value == true){
                    isLastLyric.value = false   //가사 보여주는 테이블뷰에 두번째 cell에 색을 제거
                }
                break
            }
            if(playPoint.value > lyrics_List![show_lyricIndex.value+1].time!){
                //검색할때, 현재 재생시간이 가사 시간보다 빠르면 다음 가사로 넘어가서 비교
                show_lyricIndex.value += 1
                continue
            }
            if(playPoint.value < lyrics_List![show_lyricIndex.value].time!){
                //검색할때, 현재 재생시간이 가사 시간보다 느리면 가사 주소를 하나 감소 시킨다.
                show_lyricIndex.value -= 1
                continue
            }
        }
        
        if(isPlaying.value == true && playPoint.value >= endTimePoint){
            isPlaying.value = false
        }
        
    }
    
    
}
