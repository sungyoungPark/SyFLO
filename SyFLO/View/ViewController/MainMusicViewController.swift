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
    
    
    
    func bindViewModel(){
        if let viewModel = viewModel{
            viewModel.albumImage.bind { (albumImage) in
                self.album_Image.image = albumImage
            }
            viewModel.playPoint.bind { (playPoint) in
                self.progressBar.value = playPoint
            }
            viewModel.currentPlayTime.bind { (currentPlayTime) in
                self.currentTime.text = currentPlayTime
            }
            viewModel.show_lyricIndex.bind { (index) in
                DispatchQueue.main.async {
                    self.lyricsTV.reloadData()
                }
            }
            viewModel.isFirstLyric.bind { (Bool) in
                DispatchQueue.main.async {
                    self.lyricsTV.reloadData()
                }
            }
            viewModel.isLastLyric.bind { (Bool) in
                DispatchQueue.main.async {
                    self.lyricsTV.reloadData()
                }
            }
            self.music_Title.text = viewModel.musicINFO?.title
            self.singer.text = viewModel.musicINFO?.singer
            self.finishTime.text = viewModel.timeString(time: TimeInterval(viewModel.musicINFO!.duration!))
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MainMusicViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lyricsCell1", for: indexPath) as! LyricsTableViewCell
        
        if(indexPath.row == 0){
            cell.lyrics.text = viewModel?.lyrics_List![viewModel!.show_lyricIndex.value].lyric
            cell.selectionStyle = .none  //셀 선택시 하이라이트 색 없애기
            if(viewModel?.isFirstLyric.value == true){
                if(viewModel?.isLastLyric.value == true){
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
            cell.lyrics.text = viewModel?.lyrics_List![viewModel!.show_lyricIndex.value+1].lyric
            cell.selectionStyle = .none  //셀 선택시 하이라이트 색 없애기
            if(viewModel?.isLastLyric.value == true){
                 cell.lyrics.textColor = .blue
            }
            else{
                cell.lyrics.textColor = .black
            }
            
        }
        
        return cell
    }
    
}
