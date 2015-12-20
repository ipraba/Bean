//
//  BeanTests.swift
//  BeanTests
//
//  Created by Prabaharan Elangovan on 19/12/15.
//
//

import XCTest
import Bean

class BeanTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        Cache.sharedCache.clearCache()
    }
    
    func waitOutTime(time: NSTimeInterval) {
        waitForExpectationsWithTimeout(time) { error in
            // ...
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    
    func testDownloadDataCancel() {
        
        let urlData = NSURL(string: "https://github.com/ipraba/EPContactsPicker/archive/master.zip")
        let expectation = expectationWithDescription("DownloadData Cancel: \(urlData)")
        
        let downloader = Bean.download(urlData!)
        downloader.getData { (url, data, error) -> Void in
            print(error)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code,-999) //Error code -999 indicates the user cancelled the url request
            XCTAssertNil(data)
            XCTAssertEqual(urlData, url)
            let cachedData = Cache.sharedCache.getData((urlData?.absoluteString)!)
            XCTAssertNil(cachedData)
            expectation.fulfill()
        }
        downloader.cancel(urlData!)
        waitOutTime(10)
        
    }
    
    func testDownloadData() {
        
        let urlData = NSURL(string: "https://raw.githubusercontent.com/ipraba/EPContactsPicker/master/EPContactsPickerLogo.jpg")
        let expectation = expectationWithDescription("DownloadData: \(urlData)")
        
        let downloader = Bean.download(urlData!)
        downloader.getData { (url, data, error) -> Void in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            XCTAssertEqual(urlData, url)
            
            let cachedData = Cache.sharedCache.getData((urlData?.absoluteString)!)
            XCTAssertNotNil(cachedData)

            let cachedDataImage = Cache.sharedCache.getImage((urlData?.absoluteString)!)
            XCTAssertNotNil(cachedDataImage)
            expectation.fulfill()
            
        }
        waitOutTime(10)
        
    } 
    
    
    func testDownloadImage() {
        let imageUrl = NSURL(string: "https://raw.githubusercontent.com/ipraba/EPContactsPicker/master/EPContactsPickerLogo.jpg")
        let expectation = expectationWithDescription("DownloadImage: \(imageUrl)")
        

        Bean.download(imageUrl!).getImage { (url, image, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(image)
            
            let cachedImage = Cache.sharedCache.getImage((imageUrl?.absoluteString)!)
            XCTAssertNotNil(cachedImage)
            XCTAssertEqual(cachedImage, image)
            expectation.fulfill()
        }
        waitOutTime(10)
    }
    
    
    func testDownloadImageFailure() {
        let imageUrl = NSURL(string: "https://raw.githubusercontent.com/ipraba/EPContactsPicker/master/")
        let expectation = expectationWithDescription("DownloadImage Failure: \(imageUrl)")
        
        let downloader = Bean.download(imageUrl!)
        downloader.getImage { (url, image, error) -> Void in
            XCTAssertNil(image)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        waitOutTime(10)
    }

    
    
    func testDownloadJson() {
        let jsonUrl = NSURL(string: "http://sample-file.bazadanni.com/download/txt/json/sample.json")
        let expectation = expectationWithDescription("Download Json: \(jsonUrl)")
        
        let downloader = Bean.download(jsonUrl!, shouldCache: true)
        downloader.getJSON { (url, json, error) -> Void in
            print(json)
            
            XCTAssertNil(error)
            XCTAssertNotNil(json)
            XCTAssertEqual(json!["1"] as? String, "Samlpe")
            
            let cachedJson = Cache.sharedCache.getJson((jsonUrl?.absoluteString)!)
            XCTAssertNotNil(cachedJson)
            XCTAssertEqual(json!["1"] as? String, cachedJson!["1"] as? String)
            
            let cachedImage = Cache.sharedCache.getImage((jsonUrl?.absoluteString)!)
            XCTAssertNil(cachedImage)
            
            expectation.fulfill()
        }
        
        waitOutTime(10)
    }
    
    func testDownloadJsonFailure() {
        let imageUrl = NSURL(string: "http://stackoverflow.com/users/404848/iprabu")
        let expectation = expectationWithDescription("DownloadJson Failure: \(imageUrl)")
        
        Bean.download(imageUrl!).getJSON { (url, json, error) -> Void in
            XCTAssertNil(json)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        waitOutTime(10)
    }
    
    func testDownloadImageCached() {
        let imageUrl = NSURL(string: "https://raw.githubusercontent.com/ipraba/EPContactsPicker/master/EPContactsPickerLogo.jpg")
        let expectation = expectationWithDescription("DownloadImage Cached: \(imageUrl)")
        
        let downloader = Bean.download(imageUrl!, shouldCache: true)
        downloader.getImage { (url, image, error) -> Void in
            downloader.getImage({ (url, image, error) -> Void in
                //This should get the cached image not the remote image. Check in tests coverage for execution.
                XCTAssertNil(error)
                XCTAssertNotNil(image)
                expectation.fulfill()
            })
            
        }
        waitOutTime(10)
    }
    
    func testDownloadJsonCached() {
        let jsonUrl = NSURL(string: "http://sample-file.bazadanni.com/download/txt/json/sample.json")
        let expectation = expectationWithDescription("Download Json 2cached: \(jsonUrl)")
        
        let downloader = Bean.download(jsonUrl!, shouldCache: true)
        downloader.getJSON { (url, json, error) -> Void in
            print("Something")
            downloader.getJSON({ (url, json, error) -> Void in
                print("Somethin2g")                
                //This should get the cached image not the remote image. Check in tests coverage for execution.
                XCTAssertEqual(json!["1"] as? String, "Samlpe")
                XCTAssertNil(error)
                XCTAssertNotNil(json)
                expectation.fulfill()
            })
        }
        
        waitOutTime(10)
    }
    
    func testImageView(){
        let imageUrl = NSURL(string: "https://raw.githubusercontent.com/ipraba/EPContactsPicker/master/EPContactsPickerLogo.jpg")
        let expectation = expectationWithDescription("Imageview test: \(imageUrl)")
        
        let imageView = UIImageView()
        imageView.setImageWithUrl(imageUrl!) { (error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(imageView.image)
            expectation.fulfill()
        }
        waitOutTime(10)
    }
    
    func testImageViewPlaceholder(){
        let imageUrl = NSURL(string: "https://raw.githubusercontent.com/ipraba/EPContactsPicker/master/EPContactsPickerLogo.jpg")
        let expectation = expectationWithDescription("Imageview test1: \(imageUrl)")
        
        let imageView = UIImageView()
        imageView.setImageWithUrl(imageUrl!)
        print("Call")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
        print("Call2")
            XCTAssertNotNil(imageView.image)
            expectation.fulfill()
        }
        waitOutTime(10)
    }
    
    
    func testImageViewFailure() {
        let imageUrl = NSURL(string: "https://raw.githubusercontent.com/ipraba/EPContactsPicker/master/EPContactsPickerLogo.jpg")
        let expectation = expectationWithDescription("Imageview test failure: \(imageUrl)")
        
        let imageView = UIImageView()
        Bean.download(imageUrl!).getImage { (url, image, error) -> Void in

            let imageUrl = NSURL(string: "")
            imageView.setImageWithUrl(imageUrl!, placeholderImage: image, completion: { (error) -> Void in
                XCTAssertNotNil(error)
                XCTAssertEqual(image, imageView.image)
                expectation.fulfill()
            })
        }
        
        waitOutTime(10)
        
    }

    
    
    
}
