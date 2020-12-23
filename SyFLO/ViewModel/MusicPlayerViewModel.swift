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
    //let timePlayerSelector:Selector = #selector(MusicPlayerViewModel.setCurrentPlayTime)
    
    var musicINFO : MusicModel?
    var musicPlayer : MusicPlayerModel?
    
    var albumImage = Dynamic(UIImage())
    
    
    init() {
        guard  let url = URL(string: path) else {
            print("url error")
            return
        }
        
        do{
            let stringData = try String(contentsOf: url, encoding: .utf8)
            let data = stringData.data(using: String.Encoding.utf8)
            musicINFO = try JSONDecoder().decode(MusicModel.self, from: data!)
            
            getAlbumImage()
            
            //음악 플레이어 설정
            musicPlayer = MusicPlayerModel()
            musicPlayer?.show_lyricIndex.value = 0
            musicPlayer?.setLyricsList(musicINFO!.lyrics!)
            musicPlayer?.playerItem = AVPlayerItem(url: musicINFO!.file!)
            musicPlayer?.endTimePoint = Float((musicINFO!.duration)!)
            //let playerItem:AVPlayerItem = AVPlayerItem(url: musicINFO!.file!)
            musicPlayer?.setPlayer()
            
            //player = AVPlayer(playerItem: playerItem)
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
    
    
    func musicPlay(){
        musicPlayer?.playMusic()
    }
    
    func seekMusic(_ sender: Float){
        musicPlayer?.invalidatePlayer()//seekBar를 움직일때 재생바 움직임을 제어하기 위해
        musicPlayer?.currentPlayTime.value = timetoString(time: TimeInterval(sender))
        musicPlayer?.playPoint.value = sender
       
    }
    
    func moveToSeekTime(_ sender: Float){
        
        //CMTimeMake(value: Int64(sender.value), timescale: 1) CMTime 형식으로 변환
        musicPlayer?.playPoint.value = Float(Int(sender))  //seekBar를 정확한 위치에 넣기위해 소수점을 제거하고 재생점 위치 시킴
        
        musicPlayer?.moveToSeekTime(sender)
    }
    
    
}
