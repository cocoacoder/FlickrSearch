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
    private var searches        = [FlickrSearchResults]()
    private let flickr          = Flickr()

    private var selectedPhotos  = [FlickrPhoto]()

    private var lastLongPressedIndexPath:   NSIndexPath?

    @IBOutlet private weak var flickrPhotosDetailLayout: FlickrPhotosDetailViewLayout!
    @IBOutlet var longPressGestureRecognzer: UILongPressGestureRecognizer!



    // MARK: - UICollectionViewController Methods

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }



    override func viewDidLoad()
    {
        //println("view controller viewDidLoad()")
        super.viewDidLoad()
    }



    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
    
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return searches.count
    }



    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let photoCount      = searches[section].searchResults.count

        if photoCount < 3
        {
            return photoCount
        }
        else
        {
            return 3
        }
    }



    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(detailReuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell

        let flickrPhoto = photoForIndexPath(indexPath)

        cell.activityIndicator.stopAnimating()

        cell.imageView.image    = flickrPhoto.thumbnail

        cell.activityIndicator.startAnimating()

        return cell
    }
}
