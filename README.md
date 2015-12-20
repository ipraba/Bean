# Bean

Image Downloader with Cache written in Swift

[![Version](https://img.shields.io/cocoapods/v/Bean.svg?style=flat)](http://cocoapods.org/pods/Bean)
[![License](https://img.shields.io/cocoapods/l/Bean.svg?style=flat)](https://github.com/ipraba/Bean/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/Bean.svg?style=flat)](http://cocoapods.org/pods/Bean)
[![Swift 2.0](https://img.shields.io/badge/Swift-2.0-orange.svg?style=flat)](https://developer.apple.com/swift/)

Usage
-----

Downloading Image

       Bean.download(remoteUrl).getImage { (url, image, error) -> Void in
         yourImageView.image = image
       }

Downloading Json

       Bean.download(jsonUrl!, shouldCache: true).getJSON { (url, json, error) -> Void in
          //Your JSON file
       }

You can also make use of the Imageview extensions to easily set the images

    public func setImageWithUrl(url: NSURL, completion: (error: NSError?) -> Void)
    public func setImageWithUrl(url: NSURL)
    public func setImageWithUrl(url: NSURL, placeholderImage: UIImage? = default, completion: ((error: NSError?) -> Void)?)


Caching
   
Storing in Cache

       Cache.sharedCache.storeAnyObject(obj, url: urlString)
       Cache.sharedCache.storeImage(image, url: urlString)
       
Extracting from Cache

       Cache.sharedCache.getImage(url)
       Cache.sharedCache.getData(url)

Requirements
------------
Swift 2.0
iOS8.0+

Installation
------------
Bean is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Bean"
```

License
-------
EPContactsPicker is available under the MIT license. See the [LICENSE](https://github.com/ipraba/EPContactsPicker/blob/master/LICENSE) file for more info.

Contributors
------------
[@ipraba](https://github.com/ipraba)
