//
//  ViewPhoto.swift
//  Project4
//
//  Created by Wisam Thalij on 11/9/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit
import Photos

class ViewPhoto: UIViewController {
    
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult!
    var index: Int = 0
    
    @IBAction func btnCancel(sender: AnyObject) {
        println("Cancel")
        //self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnExport(sender: AnyObject) {
        println("Export")
    }

    @IBAction func btnTrash(sender: AnyObject) {
        println("Trash")
        
        let alert = UIAlertController(title: "Delete Image", message: "Wisam Asks: Are you sure you want to delete this Image?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {(alertAction)in
            // Delete the photo
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let request = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)

                request.removeAssets([self.photosAsset[self.index]])
            
                }, completionHandler: {(success, error)in
                    NSLog("\nDeleted Image -> %@", (success ? "Success" : "Error"))
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
                    if (self.photosAsset.count == 0) {
                        // No photos left
                        self.imageView.image = nil
                        println("No Images left in the folder")
                    }
                    if (self.index >= self.photosAsset.count) {
                        self.index = self.photosAsset.count - 1
                    }
                    //self.viewWillAppear(true)
                    self.displayPhoto()
                    
            })
        
        }))
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {(alertAction ) in
            // Do Not Delete the photo
            alert.dismissViewControllerAnimated(true, completion: nil)
        
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.hidesBarsOnTap = true
        
        self.displayPhoto()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayPhoto() {
        let imageManager = PHImageManager.defaultManager()
        var ID = imageManager.requestImageForAsset(self.photosAsset[self.index] as! PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: nil, resultHandler: {(result, info)in
            self.imageView.image = result
        })
    }
    

}
