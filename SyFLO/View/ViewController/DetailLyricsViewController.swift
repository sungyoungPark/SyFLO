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
    var lyricsFontSize = 20
    
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var lyricsSizeBtn: UIButton!
    @IBOutlet var freeModeBtn: UIButton!
    @IBOutlet var gotoLyricsBtn: UIButton!
    
    @IBOutlet var sing_Title: UILabel!
    @IBOutlet var singer: UILabel!
    
    @IBOutlet var lyricsTV: UITableView!
    @IBOutlet var progressBar: UISlider!
    
    var isActiveFreeMode = false
    var isActiveGotoLyrics = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        setBtn()
        setLyricsTV()
        setProgressBar()
        
        self.view.backgroundColor = .black  //바탕화면 검은색으로
        self.navigationController?.navigationBar.barTintColor = .black //네비게이션 바 색깔 변경
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // 네비게이션 바 타이틀 색깔 변경
        
        self.navigationController?.isNavigationBarHidden = true
        
      
    }
    
    func setLyricsTV(){
        lyricsTV.delegate = self
        lyricsTV.dataSource = self
        lyricsTV.estimatedRowHeight = 50
        lyricsTV.rowHeight = UITableView.automaticDimension
    }
    
    func setProgressBar(){
        self.progressBar.maximumValue = viewModel.musicPlayer.endTimePoint
        self.progressBar.minimumValue = 0
        self.progressBar.value = viewModel.musicPlayer.playPoint.value
        
        //self.progressBar.setThumbImage(UIImage(), for: .normal)
    }
    
    func setBtn(){
        if(viewModel.musicPlayer.isPlaying.value){
            self.playBtn.setImage(UIImage(named: "stopBtn.png"), for: .normal)
        }
        else{
            self.playBtn.setImage(UIImage(named: "playBtn.png"), for: .normal)
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
                self.playBtn.setImage(UIImage(named: "stopBtn.png"), for: .normal)
            }
            else{
                self.playBtn.setImage(UIImage(named: "playBtn.png"), for: .normal)            }
        }
        self.sing_Title.text = viewModel.titleText
        self.singer.text = viewModel.singerText
    }
    
    
    
    @IBAction func pausePlayer(_ sender: Any) {  //음악 정지,시작 버튼
        
        viewModel.musicPlay()
    }
    
    @IBAction func returnMain(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func slideProgressBar(_ sender: UISlider) {  //음악 재생 위치 조절
        viewModel.seekMusic(sender.value)
        if sender.isTracking{
            return
        }
        viewModel.moveToSeekTime(sender.value)
        
    }
    
    @IBAction func changeLyricsSize(_ sender: UIButton) {
        if(lyricsSizeBtn.titleLabel?.text == "×1"){
            lyricsSizeBtn.setTitle("×2", for: .normal)
            lyricsFontSize = 30
        }
        else{
            lyricsSizeBtn.setTitle("×1", for: .normal)
            lyricsFontSize = 20
        }
        lyricsTV.reloadData()
    }
    
    @IBAction func pressFreeModeBtn(_ sender: UIButton) {
        if(isActiveFreeMode){
            self.freeModeBtn.setImage(UIImage(named: "dis_crossHair.png"), for: .normal)
            isActiveFreeMode = false
        }
        else{
            self.freeModeBtn.setImage(UIImage(named: "crossHair.png"), for: .normal)
            isActiveFreeMode = true
        }
    }
    
    @IBAction func pressGotoLyricsBtn(_ sender: UIButton) {
        if(isActiveGotoLyrics){
            self.gotoLyricsBtn.setImage(UIImage(named: "disableGoto.png"), for: .normal)
            isActiveGotoLyrics = false
        }
        else{
            self.gotoLyricsBtn.setImage(UIImage(named: "goto.png"), for: .normal)
            isActiveGotoLyrics = true
        }
    }
    
}

extension DetailLyricsViewController: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.musicPlayer.lyrics_List!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lyricsCell1", for: indexPath) as! LyricsTableViewCell
        
        cell.selectionStyle = .none  //셀 선택시 하이라이트 색 없애기
        cell.fontSize = lyricsFontSize
        cell.lyrics.text = viewModel.musicPlayer.lyrics_List![indexPath.row].lyric
        cell.setAutoLayout()
        if(viewModel.musicPlayer.isFirstLyric.value == true){
            if(viewModel.musicPlayer.isLastLyric.value == false){
                if(indexPath.row == viewModel.musicPlayer.show_lyricIndex.value){  //현재 재생 중인 가사 위치
                    cell.lyrics.textColor = .blue
                }
                else{
                    cell.lyrics.textColor = .lightGray
                }
            }
            else{
                if(indexPath.row == viewModel.musicPlayer.show_lyricIndex.value + 1){  //현재 재생 중인 가사 위치
                    cell.lyrics.textColor = .blue
                }
                else{
                    cell.lyrics.textColor = .lightGray
                }
                
            }
        }
        else{
            cell.lyrics.textColor = .lightGray
        }
        
        return cell
    }
    
    
    
}
