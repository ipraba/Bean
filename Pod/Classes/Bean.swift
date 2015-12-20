//
//  Bean.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 17/12/15.
//
//

import Foundation


/**
 Creates an downloader object using the url passed
 - parameter url:   The NSURL object containing the romte file location
 - returns:         The Downloader request.
 */

public func download(url: NSURL) -> Downloader {
    return Downloader(url: url)
}


/**
 Creates an downloader object using the url passed. But with an option of caching teh data downloaded
 - parameter url:           The NSURL object containing the remote file location
 - parameter shouldCache:   The Boolean value indicating whether to catch yet to be downloaded files
 - returns:                 The Downloader request.
 */
public func download(url: NSURL, shouldCache: Bool) -> Downloader {
    return Downloader(url: url, shouldCache: shouldCache)
}
