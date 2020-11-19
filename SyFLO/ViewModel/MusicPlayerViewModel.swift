//
//  MusicPlayViewModel.swift
//  SyFLO
//
//  Created by 박성영 on 19/11/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

//import Foundation
import UIKit

class MusicPlayerViewModel {
    
    let path = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
    var musicINFO : MusicModel?
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
  
    
}
