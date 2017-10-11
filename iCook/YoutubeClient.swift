 //
//  YoutubeClient.swift
//  iCook
//
//  Created by Udumala, Mary on 6/29/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation

class YoutubeClient {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // MARK: GET
    
    func taskForGETMethod(searchCategory: String, pageToken:String, parameters: [String: String?], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var searchParameters = parameters
        
        searchParameters[YoutubeClient.Constants.YTParameterKeys.APIKey] = YoutubeClient.Constants.YTParameterValues.APIKey
        
        searchParameters[YoutubeClient.Constants.YTParameterKeys.ContentType] = YoutubeClient.Constants.YTParameterValues.ContentType        
        searchParameters[YoutubeClient.Constants.YTParameterKeys.Order] = YoutubeClient.Constants.YTParameterValues.Order
        searchParameters[YoutubeClient.Constants.YTParameterKeys.Part] = YoutubeClient.Constants.YTParameterValues.Part
        searchParameters[YoutubeClient.Constants.YTParameterKeys.VideoDuration] = YoutubeClient.Constants.YTParameterValues.VideoDuration
        searchParameters[YoutubeClient.Constants.YTParameterKeys.videoDefinition] = YoutubeClient.Constants.YTParameterValues.videoDefinition
        searchParameters[YoutubeClient.Constants.YTParameterKeys.maxResults] = YoutubeClient.Constants.YTParameterValues.maxResults
        searchParameters[YoutubeClient.Constants.YTParameterKeys.SearchString] = searchCategory
        searchParameters[YoutubeClient.Constants.YTParameterKeys.pageToken] = pageToken
        
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: URLFromParameters(searchParameters))
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    private func URLFromParameters(_ parameters: [String: String?]) -> URL {
        
        var components = URLComponents()
        components.scheme = YoutubeClient.Constants.YT.APIScheme
        components.host = YoutubeClient.Constants.YT.APIHost
        components.path = YoutubeClient.Constants.YT.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            if let value = value {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> YoutubeClient {
        struct Singleton {
            static var sharedInstance = YoutubeClient()
        }
        return Singleton.sharedInstance
    }
    
}
