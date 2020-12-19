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
    
    var detailLyricsModel = DetailLyricsModel()
    
    init() {
        
        print("DetailLyricsViewModel 생성")
  
    }
    
    func controlPlayer(){
        
        detailLyricsModel.controlMusic()
    }
    
    
    
}
