//
//  ListViewController.swift
//  iCook
//
//  Created by Udumala, Mary on 7/10/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ListViewController: UICollectionViewController {
    
    var videos = [Video]()
    var selectedIndex = NSInteger()
    var isLoading = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 19.0)!, NSForegroundColorAttributeName : UIColor.white]
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "videoCell")
        
        getVideosFromCoreData()
    
    }
    
    
    func getVideosFromCoreData() -> Void {
        CoreDataClass.getVideosDatafunc(channelTitle: navigationItem.title!, success: { (response) in
            self.videos = [Video]()
            self.collectionView?.reloadData()
            for dictionary in response {
                let video = self.videos(videoData: dictionary as! NSManagedObject)
                self.videos.append(video)
            }
            if response.count == 0
            {
                self.getVideosFromYoutube()
            }
            self.collectionView?.reloadData()
            
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
    
    
    func getVideosFromYoutube() -> Void {
        YoutubeClient.sharedInstance().getVideos(query: navigationItem.title!, pageToken: icookPageToken(key: navigationItem.title!)) { (results, error,pageToken) in
            self.isLoading = false
            if error != nil {
                print("found an error")
                DispatchQueue.main.async {
                    CoreDataClass.alert(Constants.applicationName, message: (error?.localizedDescription)!, view: self)
                }
                
            } else {
                var check = Bool()
                icookAddPageToken(token: pageToken, key: self.navigationItem.title!)
                for dictionary in results! {
                    CoreDataClass.addVideosFunc(videoData: dictionary as NSDictionary, navTitle: self.navigationItem.title!, success: { (response) in
                        if response == true
                        {
                            check = true
                        }
                    }, failure: { (error) in
                        print(error.localizedDescription)
                    })
                }
                if check == true
                {
                    self.getVideosFromCoreData()
                }
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count 
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
        cell.options.tag = indexPath.item
        cell.options.addTarget(self, action: #selector(openOptions(sender:)), for: .touchUpInside)
        cell.video = videos[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
    lazy var optionsLauncher: OptionsLauncher  = {
        let launcher = OptionsLauncher()
        launcher.listViewController = self
        return launcher
    }()
    
    func openOptions(sender:UIButton) {
        selectedIndex = sender.tag
        optionsLauncher.showOptions(fav: videos[selectedIndex].fav, type: 1)
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
            self.videos[self.selectedIndex].fav = fav
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            if icookPageToken(key: navigationItem.title!) != "" {
                if self.isLoading == false {
                    self.isLoading = true
                    getVideosFromYoutube()
                }
            }
        }
        
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}




