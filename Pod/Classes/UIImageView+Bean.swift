//
//  BeanExtensions.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 17/12/15.
//
//

import Foundation

/**
 Extension for Imageview class
*/
public extension UIImageView {

    public func setImageWithUrl(url: NSURL, completion: (error : NSError?) -> Void) {
        self.setImageWithUrl(url, placeholderImage: nil, completion: completion)
    }
    
    public func setImageWithUrl(url: NSURL) {
        self.setImageWithUrl(url, placeholderImage: nil, completion: nil)
    }
    
    public func setImageWithUrl(url: NSURL, placeholderImage: UIImage? = nil, completion: ((error : NSError?) -> Void)?) {

        self.image = nil
        if let _ = placeholderImage {
            self.image = placeholderImage
        }
        download(url).getImage { (url, image, error) -> Void in
            if error == nil , let _ = image {
                    self.image = image!
                    Cache.sharedCache.storeImage(image!, url: url.absoluteString)
                    if let _ = completion {
                        completion!(error: nil)
                    }
            }
            else{
                if let _ = completion {
                    completion!(error: error)
                }
            }
        }
    }
}

