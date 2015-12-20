//
//  ViewController.swift
//  Bean
//
//  Created by Prabaharan on 12/17/2015.
//  Copyright (c) 2015 Prabaharan. All rights reserved.
//

import UIKit
import Bean

class ViewController: UICollectionViewController {
    
    let queue = NSOperationQueue()
    var photos = [FlickrObject]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "#Mindvalley"
        self.navigationController?.navigationBar.barTintColor = Colors.PumpkinColor
        fetchImages()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchImages(){
        fetchImagesForText("Mindvalley", page: currentPage) { (results, error) -> Void in
            print(results)
            if error == nil && results != nil {
                self.photos.appendContentsOf(results!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView?.reloadData()
                })
            }
            else{
                self.showAlert("Error in Fetching data from Flickr")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Collection view delegates
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ImagesCell
        
        let photo = photos[indexPath.row]
        let flickrURl = photo.flickrImageURL()
        
        cell.imgFlicker.image = nil
        
        //The reason for not using the Bean ImageView extension is 
        //When scrolling very fast in a collectionView or Tableview the image requests sent will start updating the imageview for all reusable cell. This will lead to a flickering effect in cells.
        //Solution extracted from this post http://stackoverflow.com/questions/16663618/async-image-loading-from-url-inside-a-uitableview-cell-image-changes-to-wrong
        Bean.download(flickrURl).getImage { (url, image, error) -> Void in
            if let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as? ImagesCell{
                currentCell.imgFlicker.image = image
            }
        }
        
        if indexPath.row == photos.count-1 { //Last Cell
            //Fetch next set of images
            currentPage++
            fetchImages()
        }
        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer", forIndexPath: indexPath)
            return header;
        }
        
        return UICollectionReusableView()
        
    }
    
    
    func fetchImagesForText(text: String, page: Int, completion : (results: [FlickrObject]?, error : NSError?) -> Void) {
        
        let escapedTerm = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        //Flickr API search string should be escaped
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FlickrConstants.apiKey)&text=\(escapedTerm)&per_page=20&page=\(page)&format=json&nojsoncallback=1"

        let request = NSURLRequest(URL: NSURL(string: URLString)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) {response, data, error in
            if error == nil {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    var photos = [FlickrObject]() //Converting into models
                    for photo in json["photos"]!["photo"] as! [[String: AnyObject]] {
                        photos.append(FlickrObject(dict: photo))
                    }
                    completion(results: photos, error: nil)
                }
                catch let jsonError as NSError {
                    completion(results: nil,error: jsonError)
                }
                return
            }
            completion(results: nil,error: error)
        }

    }
}


