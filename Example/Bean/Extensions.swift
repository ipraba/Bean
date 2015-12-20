//
//  Extensions.swift
//  Bean
//
//  Created by Prabaharan Elangovan on 17/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String) {
        showAlert(message, andTitle: "")
    }
    
    func showAlert(message: String, andTitle title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

//MARK: UICollectionView Extension
extension UICollectionView {
    
    func scrollToIndexpathByShowingHeader(indexPath: NSIndexPath) {
        let sections = self.numberOfSections()
        
        if indexPath.section <= sections{
            let attributes = self.layoutAttributesForSupplementaryElementOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
            let topOfHeader = CGPointMake(0, attributes!.frame.origin.y - self.contentInset.top)
            self.setContentOffset(topOfHeader, animated:false)
        }
    }
}