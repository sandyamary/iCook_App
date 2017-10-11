//
//  FavoritesViewController.swift
//  iCook
//
//  Created by Udumala, Mary on 7/14/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class FavoritesViewController: UIViewController {
    @IBOutlet var favCV: UICollectionView!
    var videos = [Video]()
    var selectedIndex = NSInteger()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 19.0)!, NSForegroundColorAttributeName : UIColor.white]
        favCV.backgroundColor = UIColor.white
        favCV.register(VideoCell.self, forCellWithReuseIdentifier: "videoCell")
        getVideosFromCoreData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getVideosFromCoreData() -> Void {
        
        CoreDataClass.getFavouritesVideosDatafunc(success: { (response) in
            self.videos = [Video]()
            self.favCV.reloadData()
            for dictionary in response {
                let video = self.videos(videoData: dictionary as! NSManagedObject)
                self.videos.append(video)
            }
            self.favCV.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func videos(videoData:NSManagedObject) -> Video {
        let vi = Video()
        vi.thumbnailUrl = videoData.value(forKey: VideosDataBaseKeys.thumbnailImage) as? String
        vi.title = videoData.value(forKey: VideosDataBaseKeys.title) as? String
        vi.channelTitle = videoData.value(forKey: VideosDataBaseKeys.channelTitle) as? String
        vi.videoId = videoData.value(forKey: VideosDataBaseKeys.videoID) as? String
        vi.channelId = videoData.value(forKey: VideosDataBaseKeys.channelId) as? String
        vi.fav = videoData.value(forKey: VideosDataBaseKeys.favourites) as! Bool
        return vi
    }
    
    lazy var optionsLauncher: OptionsLauncher  = {
        let launcher = OptionsLauncher()
        launcher.favouritesViewController = self
        return launcher
    }()
    
    func openOptions(sender:UIButton) {
        selectedIndex = sender.tag
        optionsLauncher.showOptions(fav: videos[selectedIndex].fav, type: 3)
    }
    
    func showFavotitesAlert() {
        
        let videoId = videos[selectedIndex].videoId
        var fav = Bool()
        var title = String()
        if  videos[selectedIndex].fav == true{
            fav = false
            title = "❤️ Removed From your Favorites"
        }else
        {
            fav = true
            title = "❤️ Added to your Favorites"
        }
        CoreDataClass.upDateVideoDataFunction(videoID: videoId!, favourites:fav , success: { (response) in
            
            self.getVideosFromCoreData()
            let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }) { (error) in
            print(error)
        }
        
        
    }
    
    func showShareOptions() {
        let textToShare = "Swift is awesome!"
        let controller = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        controller.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
}

extension FavoritesViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
        cell.options.addTarget(self, action: #selector(openOptions), for: .touchUpInside)
        cell.video = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        vc.videodID = videos[indexPath.item].videoId!
        vc.videos = videos
        vc.index = indexPath.item
        vc.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
