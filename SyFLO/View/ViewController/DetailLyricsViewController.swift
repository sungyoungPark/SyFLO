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
    
    @IBOutlet var lyricsTV: UITableView!
    @IBOutlet var progressBar: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("생성")
        //print(viewModel.detailLyricsModel.playPoint.value)
        bindViewModel()
        
        lyricsTV.delegate = self
        lyricsTV.dataSource = self
        
        self.progressBar.maximumValue = viewModel.detailLyricsModel.endTimePoint
        self.progressBar.minimumValue = 0
        self.progressBar.value = viewModel.detailLyricsModel.playPoint.value
        self.progressBar.setThumbImage(UIImage(), for: .normal)
    }
    
  
    
    
    func bindViewModel(){
        viewModel.detailLyricsModel.playPoint.bind{ (playPoint) in
            print("디테일 프로그래스바", playPoint)
            self.progressBar.value = playPoint
        }
    }
    
    
    
    @IBAction func controlPlayer(_ sender: Any) {
        
        viewModel.controlPlayer()
        
    }
    
    @IBAction func slideProgressBar(_ sender: UISlider) {
        if sender.isTracking{
            return
        }
    }
    
    
    
}

extension DetailLyricsViewController: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.detailLyricsModel.lyrics_List!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lyricsCell1", for: indexPath) as! LyricsTableViewCell
        cell.lyrics.text = viewModel.detailLyricsModel.lyrics_List![indexPath.row].lyric
        return cell
    }
    
    
}
