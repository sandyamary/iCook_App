//
//  CoreDataClass.swift
//  iCook
//
//  Created by Udumala, Mary on 7/11/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
class CoreDataClass: NSObject {
    
    class func getVideosDatafunc(channelTitle:String,success:@escaping (NSArray) -> Void, failure:@escaping (NSError) -> Void)
    {
        var appDelegate = AppDelegate()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DatBaseNames.Videos)
        let predicate = NSPredicate(format: "navTitle == %@",channelTitle)
        fetchRequest.predicate = predicate
        do {
            let arr = try managedContext.fetch(fetchRequest) as NSArray
            success(arr)
        }
        catch let error as NSError {
            failure(error)
        }
    }
    
    class func getSearchVideosDatafunc(search:String,success:@escaping (NSArray) -> Void, failure:@escaping (NSError) -> Void)
    {
        var appDelegate = AppDelegate()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DatBaseNames.Videos)
        let predicate = NSPredicate(format: "title CONTAINS[c] %@",search)
        fetchRequest.predicate = predicate
        do {
            let arr = try managedContext.fetch(fetchRequest) as NSArray
            success(arr)
        }
        catch let error as NSError {
            failure(error)
        }
    }
    
    class func getFavouritesVideosDatafunc(success:@escaping (NSArray) -> Void, failure:@escaping (NSError) -> Void)
    {
        var appDelegate = AppDelegate()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DatBaseNames.Videos)
        let predicate = NSPredicate(format: "favourites == %@",true as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let arr = try managedContext.fetch(fetchRequest) as NSArray
            success(arr)
        }
        catch let error as NSError {
            failure(error)
        }
    }
    
    class func addVideosFunc(videoData:NSDictionary,navTitle:String,success:@escaping (Bool) -> Void, failure:@escaping (NSError) -> Void) {
        var appDelegate = AppDelegate()
        
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName:DatBaseNames.Videos,in:managedContext)
        let activityData = NSManagedObject(entity: entity!,insertInto:
            managedContext)
       
        let snippet = videoData["snippet"] as! NSDictionary
        let thumbnails = snippet["thumbnails"] as! NSDictionary
        let defaultImage = thumbnails["default"] as! NSDictionary
        let url = defaultImage["url"] as! String
        let title = snippet["title"] as! String
        let channelName = snippet["channelTitle"] as! String
        let channelId = snippet["channelId"] as! String
        let description = snippet["description"] as! String
//        let etag = snippet["etag"] as! String
//        let publishedAt = snippet["publishedAt"] as! String
        let vID = videoData["id"] as! NSDictionary
        let videoId = vID["videoId"] as! String
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DatBaseNames.Videos)
        let predicate = NSPredicate(format: "videoID == %@",videoId )
        fetchRequest.predicate = predicate
        do {
            let arr = try managedContext.fetch(fetchRequest) as NSArray
            if arr.count == 0 {
                activityData.setValue(url, forKey: VideosDataBaseKeys.thumbnailImage)
                activityData.setValue(title, forKey: VideosDataBaseKeys.title)
                activityData.setValue(channelName, forKey: VideosDataBaseKeys.channelTitle)
                activityData.setValue(channelId, forKey: VideosDataBaseKeys.channelId)
                activityData.setValue(description, forKey: VideosDataBaseKeys.channelDescription)
                activityData.setValue("", forKey: VideosDataBaseKeys.etag)
                activityData.setValue("", forKey: VideosDataBaseKeys.publishedAt)
                activityData.setValue(videoId, forKey: VideosDataBaseKeys.videoID)
                activityData.setValue(false, forKey: VideosDataBaseKeys.favourites)
                activityData.setValue(navTitle, forKey: VideosDataBaseKeys.navTitle)
                do {
                    try managedContext.save()
                    success(true)
                }
                catch let error as NSError
                {
                    failure(error)
                }
            }else
            {
                success(false)
            }
        }
        catch let error as NSError {
            failure(error)
        }
        
        
    }
    class func upDateVideoDataFunction(videoID:String,favourites:Bool,success:@escaping (Bool) -> Void, failure:@escaping (NSError) -> Void)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:DatBaseNames.Videos)
        let predicate = NSPredicate(format: "videoID == %@",videoID)
        fetchRequest.predicate = predicate
        
        do {
            let arr = try managedContext.fetch(fetchRequest) as NSArray
            if arr.count > 0 {
                let activityData = arr[0]
                (activityData as AnyObject).setValue(favourites, forKey: VideosDataBaseKeys.favourites)
                do {
                    try managedContext.save()
                    success(true)
                }
                catch let error as NSError
                {
                    failure(error)
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    class func svprogressHudShow(title:String,view:UIViewController) -> Void
    {
        SVProgressHUD.show(withStatus: title);
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        view.view.isUserInteractionEnabled = false;
    }
    class func svprogressHudDismiss(view:UIViewController) -> Void
    {
        SVProgressHUD.dismiss();
        view.view.isUserInteractionEnabled = true;
    }
    
    class func alert(_ title : String, message : String, view:UIViewController)
    {
        let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
   
}
