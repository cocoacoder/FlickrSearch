//
//  FlickrPhotosDetailViewController.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 3/2/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//

import UIKit




let detailReuseIdentifier: String   = "FlickrPhotoCell"




class FlickrPhotosDetailViewController: UICollectionViewController
{
    var selectedPhotos: [FlickrPhoto]   = [FlickrPhoto]()
    var selectedPhoto: FlickrPhoto?
    var selectedPhotoLargeImage: UIImage?
    var selectedPhotosTitle: String     = "I Love Airplanes"
    var selectedPhotosSection: Int?

    private var groupPhotos             = [FlickrPhoto]()
    private let shareTextLabel          = UILabel()

    private var selectedIndexPath: NSIndexPath?
    private var lastLongPressedIndexPath:   NSIndexPath?

    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet private weak var flickrPhotosDetailLayout: FlickrPhotosDetailViewLayout!
    @IBOutlet var longPressGestureRecognzer: UILongPressGestureRecognizer! // REMOVE IF NOT ALLOWING DELETING OF INDIVIDUAL IMAGES



    // MARK: - UICollectionViewController Methods

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }



    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.collectionView?.delegate       = self

        selectedPhotosTitle                 = selectedPhotosTitle + " Photos"
        navBarItem.title                    = selectedPhotosTitle
    }



    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }




    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation)
        {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad
            {
                flickrPhotosDetailLayout.numberOfColumns    = 4

                var sideInset: CGFloat                      = UIScreen.mainScreen().preferredMode.size.width == 1136.0 ? 45.0 : 25.0

                flickrPhotosDetailLayout.itemInsets         = UIEdgeInsetsMake(22.0, sideInset, 13.0, sideInset)
            }
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                flickrPhotosDetailLayout.numberOfColumns    = 3

                var sideInset: CGFloat                      = UIScreen.mainScreen().preferredMode.size.width == 1136.0 ? 45.0 : 25.0

                flickrPhotosDetailLayout.itemInsets         = UIEdgeInsetsMake(22.0, sideInset, 13.0, sideInset)
            }
        }
        else
        {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad
            {
                flickrPhotosDetailLayout.numberOfColumns    = 3

                var inset: CGFloat                          = flickrPhotosDetailLayout.itemInsetValue
                flickrPhotosDetailLayout.itemInsets         = UIEdgeInsetsMake(inset, inset, inset, inset)
            }
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                flickrPhotosDetailLayout.numberOfColumns    = 2

                var inset: CGFloat                          = flickrPhotosDetailLayout.itemInsetValue
                flickrPhotosDetailLayout.itemInsets         = UIEdgeInsetsMake(inset, inset, inset, inset)
            }
        }
    }
    
    
    
    // MARK: - Properties

    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto
    {
        return selectedPhotos[indexPath.row]
    }
    
    
    
    func largePhotoForIndexPath(indexPath: NSIndexPath) -> Void
    {
        var photo                   = selectedPhotos[indexPath.row]

        photo.loadLargeImage{
            photo, error in
            
            //cell.activityIndicator.stopAnimating()
            
            if error != nil
            {
                println("You've got large photo!")
                return
            }
            
            if photo.largeImage == nil
            {
                println("No large photo found for the selected photo.")
                return
            }
            
            if photo.largeImage != nil
            {
                println("Returning large photo now. Size: \(photo.largeImage?.size)")
            }
        }
        
        //println("Returning large photo now. Size: \(photo.largeImage?.size)")
        //return photo
    }



    func updateSharedPhotoCount()
    {
        shareTextLabel.textColor    = UIColor.darkGrayColor()
        shareTextLabel.text         = "\(groupPhotos.count) photos selected."
        shareTextLabel.sizeToFit()
    }



    var sharing: Bool   = false
        {
        didSet
        {
            collectionView?.allowsMultipleSelection = sharing
            collectionView?.selectItemAtIndexPath(nil, animated: true, scrollPosition: .None)
            groupPhotos.removeAll(keepCapacity: false)

            let shareButton = self.navigationItem.rightBarButtonItems!.first as! UIBarButtonItem

            if sharing
            {
                updateSharedPhotoCount()
                let sharingDetailItem   = UIBarButtonItem(customView: shareTextLabel)
                navigationItem.setRightBarButtonItems([shareButton, sharingDetailItem], animated: true)
            }

            else
            {
                navigationItem.setRightBarButtonItems([shareButton], animated: true)
            }
        }
    }



    // MARK: - Action Methods

    @IBAction func share(sender: AnyObject)
    {
        if selectedPhotos.isEmpty
        {
            return
        }

        if !groupPhotos.isEmpty
        {
            var imageArray      = [UIImage]()
            for photo in self.groupPhotos
            {
                imageArray.append(photo.thumbnail!)
            }

            let shareScreen     = UIActivityViewController(activityItems: imageArray, applicationActivities: nil)
            let popover         = UIPopoverController(contentViewController: shareScreen)
            popover.presentPopoverFromBarButtonItem(self.navigationItem.rightBarButtonItems!.first as! UIBarButtonItem, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }

        sharing = !sharing
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "photoSegue"
        {
            var controller: PFFlickrPhotosPhotoViewController    = segue.destinationViewController as! PFFlickrPhotosPhotoViewController
            controller.flickrPhotoImage     = selectedPhotoLargeImage
        }
    }
    
    
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }



    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //println("number of detailed photos: \(selectedPhotos.count)")
        return selectedPhotos.count
    }



    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(detailReuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell

        let flickrPhoto = photoForIndexPath(indexPath)

        cell.imageView.image        = flickrPhoto.thumbnail
        
        cell.cellLayerSetup()
        return cell
    }
    
    
    
    // MARK: - UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        selectedIndexPath           = indexPath
        
        return true
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        selectedIndexPath           = indexPath
        
        if let photoIndexPath       = selectedIndexPath
        {
            var photo: FlickrPhoto?
            photo                   = photoForIndexPath(photoIndexPath)
            
            if photo == nil
            {
                println("Error! No photo!")
            }
            
            photo!.loadLargeImage {
                loadedFlickrPhoto, error in
                
                if error != nil
                {
                    println("No errors in obtaining a large image.")
                    return
                }
                
                if loadedFlickrPhoto.largeImage == nil
                {
                    println("Photo has no larger version.")
                    return
                }
                
                if loadedFlickrPhoto.largeImage != nil
                {
                    self.selectedPhotoLargeImage         = loadedFlickrPhoto.largeImage
                    
                    self.performSegueWithIdentifier("photoSegue", sender: self)
                    
                }
            }
        }
    }
    
}
