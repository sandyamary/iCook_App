//
//  YoutubeConvenience.swift
//  iCook
//
//  Created by Udumala, Mary on 6/30/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation

extension YoutubeClient {
    
    func getVideos(query: String ,pageToken:String, completionHandlerForVideos: @escaping (_ result: [[String: AnyObject]]?, _ error: NSError?, _ nextPageToten:String) -> Void) {
        var token = ""
        let parameters = [String:String?]()
        let _ = self.taskForGETMethod(searchCategory: query, pageToken: pageToken, parameters: parameters) { (results, error) in
            
            if let error = error {
                completionHandlerForVideos(nil, error, "")
            } else {
                if ((results?[Constants.YTResponseKeys.items]) != nil)
                {
                    if let t = results?[Constants.YTResponseKeys.nextPageToken] as? String
                    {
                        token = t
                    }
                }
                if let arrayOfVideoDictionaries = results?[Constants.YTResponseKeys.items] as? [[String: AnyObject]] {
                    completionHandlerForVideos(arrayOfVideoDictionaries, nil, token)
                }
                else {
                    completionHandlerForVideos(nil, NSError(domain: "getVideos parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getVideos"]), "")
                }
            }
        }
    }
}
