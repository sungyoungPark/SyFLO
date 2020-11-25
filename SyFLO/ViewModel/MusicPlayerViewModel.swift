//
//  MusicPlayViewModel.swift
//  SyFLO
//
//  Created by 박성영 on 19/11/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

//import Foundation
import UIKit
import AVFoundation

class MusicPlayerViewModel {
    
    let path = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
    let timePlayerSelector:Selector = #selector(MusicPlayerViewModel.setCurrentPlayTime)
    
    var musicINFO : MusicModel?
    var albumImage = Dynamic(UIImage())
    var playPoint = Dynamic(Float())  //seekBar에서 현재 진행중인 위치
    var currentPlayTime = Dynamic(String())  //현재 실행중인 노래의 시간
    var lyrics_List : [LyricsModel]? //가사 시간과 가사가 들어가 있는 리스트
    
    var show_lyricIndex = Dynamic(Int())
    var isLastLyric = Dynamic(false)
    var isFirstLyric = Dynamic(false)
    
    var progressTimer : Timer! // 타이머를 위한 변수
    
    var player:AVPlayer? {
        didSet{
            if player?.currentItem?.status == .failed {
                print("음악 URL Error")
            }
        }
    }
    var playerItem:AVPlayerItem?
    
    
    init() {
        guard  let url = URL(string: path) else {
            print("url error")
            return
        }
        
        do{
            let stringData = try String(contentsOf: url, encoding: .utf8)
            let data = stringData.data(using: String.Encoding.utf8)
            musicINFO = try JSONDecoder().decode(MusicModel.self, from: data!)
            //print(musicINFO?.file )
            show_lyricIndex.value = 0
            getAlbumImage()
            transLyrics(musicINFO!.lyrics!)
            //음악 플레이어 설정
            let playerItem:AVPlayerItem = AVPlayerItem(url: musicINFO!.file!)
            player = AVPlayer(playerItem: playerItem)
            
        }catch{
            print("스트링 변환 실패")
        }
        
    }
    
    func getAlbumImage(){
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: self.musicINFO!.image!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.albumImage.value = UIImage(data: data!)!
            }
        }
        
    }
    
    func transLyrics(_ lyrics : String){   //가사를 원하는 형식으로 바꿔줌
        lyrics_List = lyrics.replacingOccurrences(of: "[", with: "").components(separatedBy: "\n").map { (sub) -> LyricsModel in
            let str2 = sub.components(separatedBy: "]")
            let time = str2[0].components(separatedBy: ":")
            return LyricsModel(Float(Int(time[0])! * 60 + Int(time[1])!) + Float(Double(time[2])! * 0.001)
                , str2[1])
        }
    }
    
    func timeString(time: TimeInterval) -> String {  // 분:초 로 바꿔주는 함수
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        if( hour == 0 ){
            return String(format: "%02i:%02i", minute, second)
        }
        // return formated string
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    func musicPlay(){
        //player.rate = 재생속도를 의미함
        //print(player?.currentItem?.duration.seconds)  //노래 전체 시간 (duration)
        //print(player?.currentItem?.currentTime().seconds) //노래 진행 시간
        if(player?.rate == 0){
            player?.play()
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
        }
        else{
            player?.pause()
        }
    }
    
    func seekMusic(_ sender: UISlider){
        progressTimer.invalidate() //seekBar를 움직일때 재생바 움직임을 제어하기 위해
        currentPlayTime.value = timeString(time: TimeInterval(sender.value))
        playPoint.value = sender.value
    }
    
    func moveToSeekTime(_ sender: UISlider){
        player?.seek(to: CMTimeMake(value: Int64(sender.value), timescale: 1)) // seekBar 위치로 노래 이동
        //CMTimeMake(value: Int64(sender.value), timescale: 1) CMTime 형식으로 변환
        playPoint.value = Float(Int(sender.value))  //seekBar를 정확한 위치에 넣기위해 소수점을 제거하고 재생점 위치 시킴
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)  //seekMusic에서 invalidate한 것을 다시 시작
        
    }
    
    
    
    @objc func setCurrentPlayTime() {   //현재 재생시간과 가사 뷰에 보여지는 가사를 설정하는 함수
        currentPlayTime.value = timeString(time: TimeInterval((player?.currentItem?.currentTime().seconds)!))
        playPoint.value = Float((player?.currentItem?.currentTime().seconds)!)
    
        if(playPoint.value < (lyrics_List!.first?.time!)!){  //노래가 시작하고 처음 가사 시작점보다 현재 재생위치가 작을때
            isFirstLyric.value = false  //가사 보여주는 테이블에 첫번째 cell에 색을 빼주기 위함
            return
        }
        else{
            isFirstLyric.value = true   //노래 재생 시간이 처음가사 시간을 넘기면
        }
        
        while true {
            if(show_lyricIndex.value == lyrics_List!.count - 1){  //노래의 마지막 가사를 가르킬때
                isLastLyric.value = true   //가사 보여주는 테이블뷰에 두번째 cell에 색을 넣기 위함
                show_lyricIndex.value -= 1
                break
            }
            
            
            if( playPoint.value <= lyrics_List![show_lyricIndex.value+1].time! && playPoint.value > lyrics_List![show_lyricIndex.value].time!){   //노래가 현재 가사 시간에 있을때
                isLastLyric.value = false   //가사 보여주는 테이블뷰에 두번째 cell에 색을 제거
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
    }
    
}
