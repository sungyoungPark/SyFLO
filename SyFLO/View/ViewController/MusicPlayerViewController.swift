//
//  MusicPlayerViewController.swift
//  SyFLO
//
//  Created by 박성영 on 19/11/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class MusicPlayerViewController: UIViewController {
    
    var viewModel : MusicPlayerViewModel?
    
    @IBOutlet var tv: UITableView!
    
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
        
        viewModel = MusicPlayerViewModel()
        bindViewModel()
        self.title = viewModel?.musicINFO?.album
        tv.delegate = self
        tv.dataSource = self
    }
    
    func bindViewModel(){
        if let viewModel = viewModel{
            viewModel.albumImage.bind { (albumImage) in
                DispatchQueue.main.async {
                    self.tv.reloadData()
                }
            }
        }
        
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

extension MusicPlayerViewController :  UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! TitleTableViewCell
            cell.title.text = viewModel?.musicINFO!.title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "singerCell", for: indexPath) as! SingerTableViewCell
            cell.singer.text = viewModel?.musicINFO?.singer
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "album_ImageCell", for: indexPath) as! AlbumImageTableViewCell
            cell.album_Image.image = viewModel?.albumImage.value
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "lyricsCell", for: indexPath) as! LyricsTableViewCell
            cell.lyrics.text = viewModel?.musicINFO?.lyrics
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "seekBarCell", for: indexPath) as! SeekBarTableViewCell
            cell.duration.text = viewModel?.timeString(time: TimeInterval((viewModel?.musicINFO!.duration)!))
            //viewModel?.musicINFO?.duration?.description
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "album_ImageCell", for: indexPath) as! LyricsTableViewCell
            cell.lyrics.text = viewModel?.musicINFO?.lyrics
            print(viewModel?.musicINFO?.lyrics)
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var view_height = tableView.bounds.height
        //비율 2 1 10 2 2 3
        switch indexPath.row {
        case 0:
            return view_height / 20 * 2
        case 1:
            return view_height / 20 * 1
        case 2:
            return view_height / 20 * 10
        case 3:
            return view_height / 20 * 2
        case 4:
            return view_height / 20 * 2
        case 5:
            return view_height / 20 * 3
        default:
            fatalError()
        }
    }
    
    
}
