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
            getAlbumImage()
            
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
        playPoint.value = Float(Int(sender.value))  //seekBar를 정확한 위치에 넣기위해 소수점을 제거하고 재생점 위치 시킴
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)  //seekMusic에서 invalidate한 것을 다시 시작
        
    }
    
    
    
    @objc func setCurrentPlayTime() {
        currentPlayTime.value = timeString(time: TimeInterval((player?.currentItem?.currentTime().seconds)!))
        
        // let a = Double((player?.currentItem?.currentTime().seconds)!.rounded())
        // let b = Double((player?.currentItem?.duration.seconds)!.rounded())
        // print(a/b)
        playPoint.value = Float((player?.currentItem?.currentTime().seconds)!) //Float(Double((player?.currentItem?.currentTime().seconds)!)/Double((player?.currentItem?.duration.seconds)!))
    }
    
}
