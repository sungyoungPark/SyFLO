//
//  MusicModel.swift
//  SyFLO
//
//  Created by 박성영 on 19/11/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation


class MusicModel : NSObject , Decodable{
    
    var singer : String?  //아티스트명
    var album : String? //앨범명
    var title : String?    //곡명
    var duration : Int?
    var image : URL?  //앨범 커버 이미지
    var file : URL?  //mp3 파일의 링크
    
    var lyrics : String? //시간으로 구분 된 가사
    
    init(_ singer : String, _ album : String , _ title : String, _ duration : Int, _ image : URL, _ file : URL, _ lyrics : String) {
        self.singer = singer
        self.album = album
        self.title = title
        self.duration = duration
        self.image = image
        self.file = file
        self.lyrics = lyrics
    }    
    
}
