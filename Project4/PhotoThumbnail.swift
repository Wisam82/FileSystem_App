//
//  PhotoThumbnail.swift
//  Project4
//
//  Created by Wisam Thalij on 11/9/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class PhotoThumbnail: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setThumbnailImage (thumbnailImage: UIImage) {
        self.imageView.image = thumbnailImage
    }
    
}
