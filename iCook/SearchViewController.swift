//
//  SearchViewController.swift
//  iCook
//
//  Created by Udumala, Mary on 7/14/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
class SearchViewController: UIViewController {

    @IBOutlet var searchCV: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    var videos = [Video]()
    var selectedIndex = NSInteger()
    var pageToken = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 19.0)!, NSForegroundColorAttributeName : UIColor.white]
        searchCV.backgroundColor = UIColor.white
        searchCV.register(VideoCell.self, forCellWithReuseIdentifier: "videoCell")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVideosFromLocal() -> Void {
        CoreDataClass.getSearchVideosDatafunc(search: searchBar.text!, success: { (response) in
            self.videos = [Video]()
            self.searchCV.reloadData()
            for dictionary in response {
                let video = self.videos(videoData: dictionary as! NSManagedObject)
                self.videos.append(video)
            }
            self.searchCV.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getVideosFromYoutube() -> Void {
        YoutubeClient.sharedInstance().getVideos(query: searchBar.text!, pageToken: pageToken) { (results, error, pageToken) in
            SVProgressHUD.dismiss()
            if error != nil {
                print("found an error")
                DispatchQueue.main.async {
                    CoreDataClass.alert(Constants.applicationName, message: (error?.localizedDescription)!, view: self)
                }
            } else {
                self.videos = [Video]()
                DispatchQueue.main.async {
                    self.searchCV.reloadData()
                }
                for videoData in results! {
                    let snippet = videoData["snippet"] as! NSDictionary
                    let thumbnails = snippet["thumbnails"] as! NSDictionary
                    let defaultImage = thumbnails["default"] as! NSDictionary
                    let url = defaultImage["url"] as! String
                    let title = snippet["title"] as! String
                    let channelName = snippet["channelTitle"] as! String
                    let channelId = snippet["channelId"] as! String
                    //let description = snippet["description"] as! String
                    //        let etag = snippet["etag"] as! String
                    //        let publishedAt = snippet["publishedAt"] as! String
                    let vID = videoData["id"] as! NSDictionary
                    let videoId = vID["videoId"] as! String
                    
                    let vi = Video()
                    
                    vi.thumbnailUrl = url
                    vi.title = title
                    vi.channelTitle = channelName
                    vi.channelId = channelId
                    vi.videoId = videoId
                    self.videos.append(vi)
                }
                DispatchQueue.main.async {
                    self.searchCV.reloadData()
                }
            }
        }
    }
    func videos(videoData:NSManagedObject) -> Video {
        let vi = Video()
        vi.thumbnailUrl = videoData.value(forKey: VideosDataBaseKeys.thumbnailImage) as? String
        vi.title = videoData.value(forKey: VideosDataBaseKeys.title) as? String
        vi.channelTitle = videoData.value(forKey: VideosDataBaseKeys.channelTitle) as? String
        vi.videoId = videoData.value(forKey: VideosDataBaseKeys.videoID) as? String
        vi.channelId = videoData.value(forKey: VideosDataBaseKeys.channelId) as? String
        return vi
    }
    lazy var optionsLauncher: OptionsLauncher  = {
        let launcher = OptionsLauncher()
        launcher.searchViewController = self
        return launcher
    }()
    
    func openOptions(sender:UIButton) {
        actionSheet(sender: sender);
    }
    func actionSheet(sender:UIButton)
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Type", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let Share = UIAlertAction(title: "Share", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.showShareOptions()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        alert.addAction(Share)
        alert.addAction(cancelAction)
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            if let currentPopoverpresentioncontroller = alert.popoverPresentationController
            {
                currentPopoverpresentioncontroller.sourceView = sender
                currentPopoverpresentioncontroller.sourceRect = sender.bounds
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up;
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            self.present(alert, animated: true, completion: nil)
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

}

extension SearchViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
extension SearchViewController : UISearchBarDelegate
{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.enablesReturnKeyAutomatically = false;
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        getVideosFromLocal()
        SVProgressHUD.show()
        getVideosFromYoutube()
        
    }
}
