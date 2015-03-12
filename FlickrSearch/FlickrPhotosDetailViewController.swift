//
//  FlickrPhotosDetailViewController.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 3/2/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//

import UIKit




let detailReuseIdentifier: String   = "FlickrPhotoCell"




class FlickrPhotosDetailViewController:
    UICollectionViewController
{
    var selectedPhotos              = [FlickrPhoto]()
    var selectedPhotosTitle: String = "I Love Airplanes"
    var photosSection: Int          = 0

    private var groupPhotos         = [FlickrPhoto]()
    private let shareTextLabel      = UILabel()

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



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }



    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        println("number of detailed photos: \(selectedPhotos.count)")
        return selectedPhotos.count
    }



    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(detailReuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell

        //println("detailed photo")

        let flickrPhoto = photoForIndexPath(indexPath)

        //cell.activityIndicator.stopAnimating()

        cell.imageView.image    = flickrPhoto.thumbnail

        //cell.activityIndicator.startAnimating()

        cell.cellLayerSetup()
        return cell
    }
    
}
