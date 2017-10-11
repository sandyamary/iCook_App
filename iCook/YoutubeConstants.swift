//
//  YoutubeConstants.swift
//  iCook
//
//  Created by Udumala, Mary on 6/30/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation

extension YoutubeClient {
    
    struct Constants {
        
        // MARK: YT
        struct YT {
            static let APIScheme = "https"
            static let APIHost = "www.googleapis.com"
            static let APIPath = "/youtube/v3/search"
        }
        
        // MARK: YT Parameter Values
        //https://www.googleapis.com/youtube/v3/search?part=snippet&order=date&q=kids+meal+recipe&type=video&videoDuration=short&key={YOUR_API_KEY}
        
        
        struct YTParameterKeys {
            static let Part = "part"
            static let APIKey = "key"
            static let Order = "order"
            static let SearchString = "q"
            static let ContentType = "type"
            static let VideoDuration = "videoDuration"
            static let videoDefinition = "videoDefinition"
            static let maxResults = "maxResults"
            static let pageToken = "pageToken"
        }
        
        struct YTParameterValues {
            static let Part = "snippet"
            static let APIKey = "AIzaSyBFoDO2Eko9lheKUD4CA8rBnK6eVxKf9ZM"
            static let Order = "rating"
            static let ContentType = "video"
            static let VideoDuration = "short"
            static let videoDefinition = "high"
            static let maxResults = "25"
        }
        
        // MARK: youtube Response Keys
        struct YTResponseKeys {
            static let items = "items"
            static let videoId = "videoId"
            static let channelId = "channelId"
            static let Title = "title"
            static let thumbnail = "url"
            static let channelTitle = "channelTitle"
            static let nextPageToken = "nextPageToken"
            static let snippet = "snippet"
            static let statistics = "statistics"
        }
        
    }
    
}
