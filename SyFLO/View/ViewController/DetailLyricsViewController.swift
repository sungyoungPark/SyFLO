//
//  DetailLyricsViewController.swift
//  SyFLO
//
//  Created by 박성영 on 2020/12/14.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class DetailLyricsViewController: UIViewController {
    
    var viewModel = DetailLyricsViewModel()
    
    @IBOutlet var playBtn: UIButton!
    
    @IBOutlet var lyricsTV: UITableView!
    @IBOutlet var progressBar: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBtn()
        
        bindViewModel()
        
        lyricsTV.delegate = self
        lyricsTV.dataSource = self
        
        self.progressBar.maximumValue = viewModel.musicPlayer.endTimePoint
        self.progressBar.minimumValue = 0
        self.progressBar.value = viewModel.musicPlayer.playPoint.value
        self.progressBar.setThumbImage(UIImage(), for: .normal)
    }
    
    
    func setBtn(){
        if(viewModel.musicPlayer.isPlaying.value){
            self.playBtn.setTitle("⏹", for: .normal)
        }
        else{
            self.playBtn.setTitle("▶️", for: .normal)
        }
    }
    
    func bindViewModel(){
        viewModel.musicPlayer.playPoint.bind{ (playPoint) in
            //print("디테일 프로그래스바", playPoint)
            self.progressBar.value = playPoint
        }
        viewModel.musicPlayer.show_lyricIndex.bind { (index) in
            DispatchQueue.main.async {
                self.lyricsTV.reloadData()
            }
        }
        viewModel.musicPlayer.isFirstLyric.bind { (Bool) in
            DispatchQueue.main.async {
                self.lyricsTV.reloadData()
            }
        }
        viewModel.musicPlayer.isLastLyric.bind { (Bool) in
            DispatchQueue.main.async {
                self.lyricsTV.reloadData()
            }
        }
        viewModel.musicPlayer.isPlaying.bind { (isPlaying) in
            if(isPlaying){
                self.playBtn.setTitle("⏹", for: .normal)
            }
            else{
                self.playBtn.setTitle("▶️", for: .normal)
            }
        }
    }
    
    
    
    @IBAction func pausePlayer(_ sender: Any) {  //음악 정지,시작 버튼
        
        viewModel.musicPlay()
    }
    
    @IBAction func slideProgressBar(_ sender: UISlider) {  //음악 재생 위치 조절
        viewModel.seekMusic(sender.value)
        if sender.isTracking{
            return
        }
        viewModel.moveToSeekTime(sender.value)
        
    }
    
    
    
}

extension DetailLyricsViewController: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.musicPlayer.lyrics_List!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lyricsCell1", for: indexPath) as! LyricsTableViewCell
        
        cell.selectionStyle = .none  //셀 선택시 하이라이트 색 없애기
        
        cell.lyrics.text = viewModel.musicPlayer.lyrics_List![indexPath.row].lyric
        
        if(viewModel.musicPlayer.isFirstLyric.value == true){
            if(viewModel.musicPlayer.isLastLyric.value == false){
                if(indexPath.row == viewModel.musicPlayer.show_lyricIndex.value){  //현재 재생 중인 가사 위치
                    cell.lyrics.textColor = .blue
                }
                else{
                    cell.lyrics.textColor = .black
                }
            }
            else{
                if(indexPath.row == viewModel.musicPlayer.show_lyricIndex.value + 1){  //현재 재생 중인 가사 위치
                    cell.lyrics.textColor = .blue
                }
                else{
                    cell.lyrics.textColor = .black
                }
                
            }
        }
        else{
            cell.lyrics.textColor = .black
        }
        
        return cell
    }
    
    
}
