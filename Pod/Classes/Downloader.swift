//
//  Downloader.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 17/12/15.
//
//

import Foundation

public class Downloader: NSObject {

//MARK: Properties
    var session: NSURLSession
    let url: NSURL
    var isCaching: Bool

//MARK: Initializers
    init(url: NSURL, shouldCache: Bool) {
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        self.url = url
        self.isCaching = shouldCache
        super.init()
    }
    
    convenience init(url: NSURL) {
        self.init(url: url, shouldCache: true)
    }
    
//MARK: Internal methods
    
    func download(completion: (data: NSData?, error : NSError?) -> Void) {
        print("Downloading: \(url.absoluteString)")
        session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            print("Downloading Finished: \(self.url.absoluteString)")
            print("Downloading Finished: Error \(error)")
            if (error != nil) {
                completion(data: nil, error: error)
            }
            if let _ = data {
                completion(data: data, error: nil)
            }
            self.session.finishTasksAndInvalidate()
        }).resume()
        
    }
    
    func storeInCache(obj: AnyObject){
        if self.isCaching {
            Cache.sharedCache.storeAnyObject(obj, url: url.absoluteString)
        }
    }
    
    
    

//MARK: Public Methods
    public func getData(completion: (url: NSURL, data: NSData?, error : NSError?) -> Void) {
            self.download{ (data, error) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if error == nil , let _ = data{
                        self.storeInCache(data!)
                    }
                completion(url: self.url, data: data, error: error)
            }
        }
    }
    
    
    
    public func getImage(completion: (url: NSURL, image: UIImage?, error : NSError?) -> Void) {
        //The reason for dispatching it in mainqueue is
        //When the completion block is execute user tend to apply the image to a UIControl so in that case they have to dispatch the main queue to update the UI. But we reduce the overhead for them to use the GCD.
        if let cachedImage = Cache.sharedCache.getImage(self.url.absoluteString) {
            dispatch_async(dispatch_get_main_queue()) {
                completion(url: self.url, image: cachedImage, error: nil)
            }
            return
        }
        else{
            download{ (data, error) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if let thisData = data, let currentImage = UIImage(data: thisData) {
                        self.storeInCache(currentImage)
                        completion(url: self.url, image: currentImage, error: nil)
                    }
                    else {
                        completion(url: self.url, image: nil,  error: NSError(domain: "BeanError", code: -8000, userInfo: nil))
                    }
                }
            }
        }
    }
    
    //For getting the JSON objects
    public func getJSON(completion: (url: NSURL, json: [String: AnyObject]?, error : NSError?) -> Void) {
        if let cachedJson = Cache.sharedCache.getJson(self.url.absoluteString) {
            //Returns Cached JSON
            dispatch_async(dispatch_get_main_queue()) {
                completion(url: self.url, json: cachedJson, error: nil)
                return
            }
        }
        else{
            download{ (data, error) -> Void in
                do{
                    //Converts data into JSON by serialization
                    if let thisData = data, let json = try NSJSONSerialization.JSONObjectWithData(thisData, options:.AllowFragments) as? [String: AnyObject] {
                        self.storeInCache(json)
                        completion(url: self.url, json: json, error: nil)
                    }
                    else {
                        completion(url: self.url, json: nil,  error: error)
                    }
                }
                catch let jsonError as NSError {
                    completion(url: self.url, json: nil, error: jsonError)
                }
            }
        }
    }

    public func cancel(url: NSURL){
        //Iterate through all the tasks and cancel the task with the url
        session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) -> Void in
            let tasks = dataTasks.filter({ (currentTask) -> Bool in
                print(currentTask.originalRequest?.URL)
                return (currentTask.originalRequest?.URL == url)
            })
            for task in tasks {
                task.cancel()
            }
        }
    }

    
}


