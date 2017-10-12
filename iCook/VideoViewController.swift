//
//  VideoViewController.swift
//  iCook
//
//  Created by Udumala, Mary on 7/14/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper
import MediaPlayer

class VideoViewController: UIViewController {
    
    @IBOutlet weak var channelNameLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet var play: UIButton!
    @IBOutlet var nextBTN: UIButton!
    @IBOutlet var priviousBTN: UIButton!
    var videos = [Video]()
    var index = NSInteger()
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var videoView: YTPlayerView!
    var videodID = String()
    var totalTime = Float()
    var currentTime = Float()
    var isPlaying = Bool()
    var menuBarItem = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataClass.svprogressHudShow(title: "Loading...", view: self)
        
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            reachability.stopNotifier()
            CoreDataClass.svprogressHudDismiss(view: self)
            CoreDataClass.alert(Constants.applicationName, message: "No Internet Connection", view: self)
        }
        
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        videoView.isUserInteractionEnabled = true
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 19.0)!, NSForegroundColorAttributeName : UIColor.white]
        videoView.delegate = self
        videoView.load(withVideoId: videodID, playerVars: [
            "controls" : 1,
            "playsinline" : 1,
            "autohide" : 1,
            "showinfo" : 0,
            "modestbranding" : 0])
        self.title = ""
        titleLBL.text = videos[index].title
        channelNameLBL.text = videos[index].channelTitle
        volumeSlider.value = 1;
        
        setUpNavBarItem()
        if  !videos[index].fav {
            navigationItem.rightBarButtonItem = nil
        }
    }

    @IBAction func previousBTNTap(_ sender: Any) {
        if index != 0 {
            index = index-1
            currentTime = 0
            videoMethod()
        }
    }
    
    
    
    @IBAction func nextBTNTap(_ sender: Any) {
        if index != videos.count-1 {
            index = index+1
            currentTime = 0
            videoMethod()
        }
    }
    func setUpNavBarItem() {
        let menuItem = UIImage(named: "FavIcon")?.withRenderingMode(.alwaysOriginal)
        menuBarItem.setImage(menuItem, for: .normal)
        menuBarItem.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuBarItem.addTarget(self, action: #selector(favAction), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: menuBarItem)
        navigationItem.rightBarButtonItem = item1
    }
    func favAction() -> Void {
        
    }
    
    func videoMethod() {
        videodID = videos[index].videoId!
        videoView.load(withVideoId: videodID, playerVars: [
            "controls" : 1,
            "playsinline" : 1,
            "autohide" : 1,
            "showinfo" : 0,
            "modestbranding" : 0])
        isPlaying = false
        play.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        titleLBL.text = videos[index].title
        channelNameLBL.text = videos[index].channelTitle
        CoreDataClass.svprogressHudShow(title: "Loading...", view: self)
        setUpNavBarItem()
        if  !videos[index].fav {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(sender.value, animated: false)
    }
    
    @IBAction func playBTN(_ sender: Any) {
        if isPlaying == true {
            isPlaying = false
            play.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            videoView.pauseVideo()
        }else
        {
            CoreDataClass.svprogressHudShow(title: "Loading...", view: self)
            isPlaying = true
            play.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            videoView.playVideo()
        }
    }
    
    
}
extension VideoViewController : YTPlayerViewDelegate
{
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        totalTime = Float(playerView.duration())
        CoreDataClass.svprogressHudDismiss(view: self)
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        currentTime = playTime
        isPlaying = true
        play.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == YTPlayerState.playing
        {
            CoreDataClass.svprogressHudDismiss(view: self)
            isPlaying = true
            play.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            
        }else
        if state == YTPlayerState.paused
        {
            isPlaying = false
            play.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }

    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        CoreDataClass.svprogressHudDismiss(view: self)
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        
    }
    
    
}
