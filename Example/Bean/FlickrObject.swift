//
//  FlickrObject.swift
//  Bean
//
//  Created by Prabaharan Elangovan on 20/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit

class FlickrObject : NSObject {
    
    let photoID : String
    let server : String
    let farm : Int
    let secret : String
    
    init (dict: [String: AnyObject]) {
        self.photoID = dict["id"] as! String
        self.server = dict["server"] as! String
        self.farm = dict["farm"] as! Int
        self.secret = dict["secret"] as! String
        super.init()
    }
    
    func flickrImageURL(size:String = "m") -> NSURL {
        let flickrUrl = "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg"
        print(flickrUrl)
        return NSURL(string: flickrUrl)!
    }
}
