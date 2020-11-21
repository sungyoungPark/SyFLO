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
        //self.progressBar.minimumTrackTintColor = .clear
        self.progressBar.thumbTintColor = .clear
        //self.progressBar.
    }
    
    
    
    
    func bindViewModel(){
        if let viewModel = viewModel{
            viewModel.albumImage.bind { (albumImage) in
                self.album_Image.image = albumImage
            }
            viewModel.playPoint.bind { (playPoint) in
                print(playPoint)
            
                self.progressBar.value = playPoint
            }
            viewModel.currentPlayTime.bind { (currentPlayTime) in
                self.currentTime.text = currentPlayTime
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
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "lyricsCell1", for: indexPath) as! LyricsTableViewCell
            cell.lyrics.text = "hello"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "lyricsCell2", for: indexPath) as! LyricsTableViewCell
            cell.lyrics.text = "hi"
            return cell
        default:
            fatalError()
        }
    }
    
    
}
