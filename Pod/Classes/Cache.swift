//
//  BeanBag.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 17/12/15.
//
//

import Foundation

/**
 Cache is a lightweight wrapper around NSCache
*/
public class Cache {
    
    static public let sharedCache = Cache() //Singleton
    
    let cache = NSCache()
    
//MARK: Initializers
    
    init(cacheCountLimit: Int, cacheSizeLimit: Int) {
        cache.countLimit = cacheCountLimit
        cache.totalCostLimit = cacheSizeLimit
    }
    
    convenience init(){
        self.init(cacheCountLimit: 0,cacheSizeLimit: 0)
    }
    
//MARK: Public Methods
    
    public func storeImage(image: UIImage, url: String) {
        cache.setObject(image, forKey: url)
    }

    public func storeAnyObject(any: AnyObject, url: String) {
        cache.setObject(any, forKey: url)
    }
    
    public func getJson(url: String) -> [String: AnyObject]? {
        if let obj = cache.objectForKey(url) {
            return obj as? [String: AnyObject]
        }
        return nil
    }
    
    public func getData(url: String) -> NSData? {
        if let obj = cache.objectForKey(url) {
            return obj as? NSData
        }
        return nil
    }
    
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    public func getImage(url: String) -> UIImage? {

        if let obj = cache.objectForKey(url) {
            switch (obj.self) {
            case is UIImage:
                return obj as? UIImage
            case  is NSData:
                return UIImage(data: obj as! NSData)
            default :
                return nil
            }
        }
        return nil
    }
}
