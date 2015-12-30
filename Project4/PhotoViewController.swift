//
//  PhotoViewController.swift
//  Project4
//
//  Created by Wisam Thalij on 11/9/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "PhotoCell"
let albumName = "My App"

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult!
    var albumFound: Bool = false
    
    // Actions and Outlets
    
    @IBAction func btnCamera(sender: AnyObject) {
        println("camera")
        if(UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera)){
            // Load the camera interface
            var picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
            
        }else{
            // No camera is available
            var alert = UIAlertController(title: "Error", message: "There is no camera Available on Wisam's Device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default , handler: {(alertAction)in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func btnPhotoAlbum(sender: AnyObject) {
        println("Album")
        var picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if the folder exist, if not, create it
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        if (collection.firstObject != nil) {
            // We Found the collection folder
            self.albumFound = true
            self.assetCollection = collection.firstObject as! PHAssetCollection
        } else {
            // We create the folder
            NSLog("\nFolder \"%@\" dose not exist\nCreating now...", albumName)
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(albumName)
            
                }, completionHandler: {(success: Bool, error: NSError!)in
                    NSLog("Creation of folder -> %@", (success ? "Success" : "Error!"))
                    self.albumFound = (success ? true:false)
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Fetch the photos from collection
        self.navigationController?.hidesBarsOnTap = false
        
        self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
        
        // Handle no photos in the assetCollection
        
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier as String? == "viewLargePhoto") {
            let controller:ViewPhoto = segue.destinationViewController as! ViewPhoto
            let indexPath: NSIndexPath = self.collectionView.indexPathForCell(sender as! UICollectionViewCell)!
            controller.index = indexPath.item
            controller.photosAsset = self.photosAsset
            controller.assetCollection = self.assetCollection
        }
    }
    
    // UIcollectionView DataSourse Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        if (self.photosAsset != nil) {
            count =  self.photosAsset.count
        }
        return count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: PhotoThumbnail = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoThumbnail
        
        // Modifing the Cell
        let asset: PHAsset = self.photosAsset[indexPath.item] as! PHAsset
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: nil, resultHandler: {(result, info)in
            cell.setThumbnailImage(result)
        })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    // UIImagePickerControllerDelage Methods to handle the photo library selection and the camera actions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject]) {
        
        var image: UIImage!
        
        // fetch the selected image
        if picker.allowsEditing {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        } else {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        // Add the image to the Gallary folder
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let assetPlaceHolder = createAssetRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset)
            albumChangeRequest.addAssets([assetPlaceHolder])
            
            }, completionHandler: {(success, error)in
                NSLog("Adding Image to the library -> %@", (success ? "Success" : "Error"))
        
                // dissmiss the image picker controller window
                self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
        
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    

    

}
