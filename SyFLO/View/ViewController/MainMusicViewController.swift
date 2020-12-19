//
//  MainMusicViewController.swift
//  SyFLO
//
//  Created by 박성영 on 20/11/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class MainMusicViewController: UIViewController {
    
    var viewModel : MusicPlayerViewModel?
    
    @IBOutlet var music_Title: UILabel!
    @IBOutlet var singer: UILabel!
    @IBOutlet var album_Image: UIImageView!
    @IBOutlet var lyricsTV: UITableView!
    
    
    @IBOutlet var progressBar: UISlider!
    
    
    @IBOutlet var currentTime: UILabel!
    @IBOutlet var finishTime: UILabel!
    
    @IBOutlet var playBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //상태바 검은 화면으로
        let statusBar1 =  UIView()
        statusBar1.frame = UIApplication.shared.statusBarFrame
        statusBar1.backgroundColor = .black
        UIApplication.shared.keyWindow?.addSubview(statusBar1)
        UIApplication.shared.statusBarStyle = .lightContent
        //
        
        self.view.backgroundColor = .black  //바탕화면 검은색으로
        self.navigationController?.navigationBar.barTintColor = .black //네비게이션 바 색깔 변경
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // 네비게이션 바 타이틀 색깔 변경
        
        viewModel = MusicPlayerViewModel()
        bindViewModel()
        self.title = viewModel?.musicINFO?.album
        lyricsTV.delegate = self
        lyricsTV.dataSource = self
        
        self.progressBar.maximumValue = Float((viewModel?.musicINFO!.duration)!)
        self.progressBar.minimumValue = 0
        self.progressBar.setThumbImage(UIImage(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
    }
    
    
    func bindViewModel(){
        if let viewModel = viewModel{
            viewModel.albumImage.bind { (albumImage) in
                self.album_Image.image = albumImage
            }
            viewModel.musicPlayer?.playPoint.bind { (playPoint) in
                print("기본 프로그래스바", playPoint)
                self.progressBar.value = playPoint
            }
            viewModel.musicPlayer?.currentPlayTime.bind { (currentPlayTime) in
                self.currentTime.text = currentPlayTime
            }
            viewModel.musicPlayer?.show_lyricIndex.bind { (index) in
                DispatchQueue.main.async {
                    self.lyricsTV.reloadData()
                }
            }
            viewModel.musicPlayer?.isFirstLyric.bind { (Bool) in
                DispatchQueue.main.async {
                    self.lyricsTV.reloadData()
                }
            }
            viewModel.musicPlayer?.isLastLyric.bind { (Bool) in
                DispatchQueue.main.async {
                    self.lyricsTV.reloadData()
                }
            }
            self.music_Title.text = viewModel.musicINFO?.title
            self.singer.text = viewModel.musicINFO?.singer
            self.finishTime.text = viewModel.musicPlayer?.timeString(time: TimeInterval(viewModel.musicINFO!.duration!))
        }
    }
    
    @IBAction func playBtnTapped(_ sender: Any) {
        print("btn 클릭")
        viewModel?.musicPlay()
    }
    
    @IBAction func slideProgressBar(_ sender: UISlider) {
        viewModel?.seekMusic(sender)
        if sender.isTracking{
            return
        }
        viewModel?.moveToSeekTime(sender)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailLyrics" {
            let DetailLyricsViewController = segue.destination as! DetailLyricsViewController
            DetailLyricsViewController.viewModel.detailLyricsModel.player = viewModel?.musicPlayer?.player
            DetailLyricsViewController.viewModel.detailLyricsModel.lyrics_List = viewModel?.musicPlayer?.lyrics_List
            
            DetailLyricsViewController.viewModel.detailLyricsModel.playPoint = (viewModel?.musicPlayer!.playPoint)!
            
            DetailLyricsViewController.viewModel.detailLyricsModel.endTimePoint = Float((viewModel?.musicINFO!.duration)!)
            
            DetailLyricsViewController.viewModel.detailLyricsModel.progressTimer = viewModel?.musicPlayer?.progressTimer
        }
        
    }
    
    
}

extension MainMusicViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lyricsCell1", for: indexPath) as! LyricsTableViewCell
        
        if(indexPath.row == 0){
            cell.lyrics.text = viewModel?.musicPlayer?.lyrics_List![(viewModel!.musicPlayer!.show_lyricIndex.value)].lyric
            cell.selectionStyle = .none  //셀 선택시 하이라이트 색 없애기
            if(viewModel?.musicPlayer?.isFirstLyric.value == true){
                if(viewModel?.musicPlayer?.isLastLyric.value == true){
                    cell.lyrics.textColor = .black
                }
                else{
                    cell.lyrics.textColor = .blue
                }
            }
            else{
                cell.lyrics.textColor = .black
            }
        }
        
        if(indexPath.row == 1){
            cell.lyrics.text = viewModel?.musicPlayer?.lyrics_List![(viewModel!.musicPlayer!.show_lyricIndex.value)+1].lyric
            cell.selectionStyle = .none  //셀 선택시 하이라이트 색 없애기
            if(viewModel?.musicPlayer?.isLastLyric.value == true){
                cell.lyrics.textColor = .blue
            }
            else{
                cell.lyrics.textColor = .black
            }
            
        }
        
        return cell
    }
    
}
