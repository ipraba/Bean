//
//  ImagesCell.swift
//  Bean
//
//  Created by Prabaharan Elangovan on 17/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit

class ImagesCell: UICollectionViewCell {

    @IBOutlet weak var imgFlicker: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgFlicker.layer.cornerRadius = imgFlicker.frame.size.width/2
        imgFlicker.layer.borderWidth = 2.0
        imgFlicker.layer.borderColor = Colors.PumpkinColor.CGColor
        imgFlicker.layer.masksToBounds = true
    }
}
