//
//  FlickrPhotosViewController.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 1/12/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//

import UIKit




let reuseIdentifier: String = "FlickrCell"




class FlickrPhotosViewController:
    UICollectionViewController,
    UITextFieldDelegate
{
    private var searches        = [FlickrSearchResults]()
    private let flickr          = Flickr()
    private var selectedPhotos  = [FlickrPhoto]()
    private let shareTextLabel  = UILabel()

    @IBOutlet private weak var flickrPhotosLayout: FlickrPhotosViewLayout!


    /*
    override init(collectionViewLayout layout: UICollectionViewLayout!)
    {
        super.init(collectionViewLayout: layout)

        collectionView?.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)

        collectionView?.backgroundColor     = UIColor(white: 0.85, alpha: 1.0)
    }
    */

    /*
    convenience required init(coder aDecoder: NSCoder)
    {
        let collectionLayout    = FlickrPhotosViewLayout()

        self.init(collectionViewLayout: collectionLayout)
    }
    */


    override func viewDidLoad()
    {
        println("view controller viewDidLoad()")
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(FlickrPhotoCell.self, forCellWithReuseIdentifier: "FlickrCell")

        // Do any additional setup after loading the view.
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
                flickrPhotosLayout.numberOfColumns  = 4

                var sideInset: CGFloat              = UIScreen.mainScreen().preferredMode.size.width == 1136.0 ? 45.0 : 25.0

                flickrPhotosLayout.itemInsets       = UIEdgeInsetsMake(22.0, sideInset, 13.0, sideInset)
            }
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                flickrPhotosLayout.numberOfColumns  = 3

                var sideInset: CGFloat              = UIScreen.mainScreen().preferredMode.size.width == 1136.0 ? 45.0 : 25.0

                flickrPhotosLayout.itemInsets       = UIEdgeInsetsMake(22.0, sideInset, 13.0, sideInset)
            }
        }
        else
        {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad
            {
                flickrPhotosLayout.numberOfColumns  = 3

                var inset: CGFloat                  = flickrPhotosLayout.itemInsetValue
                flickrPhotosLayout.itemInsets       = UIEdgeInsetsMake(inset, inset, inset, inset)
            }
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                flickrPhotosLayout.numberOfColumns  = 2

                var inset: CGFloat                  = flickrPhotosLayout.itemInsetValue
                flickrPhotosLayout.itemInsets       = UIEdgeInsetsMake(inset, inset, inset, inset)
            }
        }
    }



    // MARK: - Properties

    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto
    {
        return searches[indexPath.section].searchResults[indexPath.row]
    }



    var largePhotoIndexPath: NSIndexPath?
        {
        didSet
        {
            var indexPaths  = [NSIndexPath]()

            if largePhotoIndexPath != nil
            {
                indexPaths.append(largePhotoIndexPath!)
            }

            if oldValue != nil
            {
                indexPaths.append(oldValue!)
            }

            collectionView?.performBatchUpdates(
                {
                    self.collectionView?.reloadItemsAtIndexPaths(indexPaths)
                    return
                }){
                    completed in
                    if self.largePhotoIndexPath != nil
                    {
                        self.collectionView?.scrollToItemAtIndexPath(
                            self.largePhotoIndexPath!,
                            atScrollPosition: .CenteredVertically,
                            animated: true)
                    }
            }
        }
    }



    func updateSharedPhotoCount()
    {
        shareTextLabel.textColor    = UIColor.darkGrayColor()
        shareTextLabel.text         = "\(selectedPhotos.count) photos selected."
        shareTextLabel.sizeToFit()
    }



    var sharing: Bool   = false
    {
        didSet
        {
            collectionView?.allowsMultipleSelection = sharing
            collectionView?.selectItemAtIndexPath(nil, animated: true, scrollPosition: .None)
            selectedPhotos.removeAll(keepCapacity: false)

            if sharing && largePhotoIndexPath != nil
            {
                largePhotoIndexPath     = nil
            }

            let shareButton = self.navigationItem.rightBarButtonItems!.first as UIBarButtonItem

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
        if searches.isEmpty
        {
            return
        }

        if !selectedPhotos.isEmpty
        {
            var imageArray      = [UIImage]()
            for photo in self.selectedPhotos
            {
                imageArray.append(photo.thumbnail!)
            }

            let shareScreen     = UIActivityViewController(activityItems: imageArray, applicationActivities: nil)
            let popover         = UIPopoverController(contentViewController: shareScreen)
            popover.presentPopoverFromBarButtonItem(self.navigationItem.rightBarButtonItems!.first as UIBarButtonItem, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }

        sharing = !sharing
    }




    // MARK: - Text Field Delegate Methods

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // 1
        let activityIndicator   = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        flickr.searchFlickrForTerm(textField.text)
        {
            results, error in

            println("results: \(results)")

            // 2
            activityIndicator.removeFromSuperview()
            if error != nil
            {
                println("Error Searching : \(error)")
                let errorAlert  = UIAlertView(title: "Oops!", message: "The Internet connection appears to be offline.", delegate: self, cancelButtonTitle: "Ok")
                errorAlert.show()
            }

            if results != nil
            {
                // 3
                println("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
                self.searches.insert(results!, atIndex: 0)

                // 4
                self.collectionView?.reloadData()
            }

            if results == nil
            {
                let errorAlert  = UIAlertView(title: "Oops!", message: "Your search resulted in no photos. Please try searching again. Thanks.", delegate: self, cancelButtonTitle: "Ok")
                errorAlert.show()
            }
        }

        textField.text  = nil
        textField.resignFirstResponder()
        return true
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
        return searches.count
    }



    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return searches[section].searchResults.count
    }



    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as FlickrPhotoCell

        let flickrPhoto = photoForIndexPath(indexPath)
        //cell.backgroundColor = UIColor.blackColor()

        cell.activityIndicator.stopAnimating()

        if indexPath != largePhotoIndexPath
        {
            cell.imageView.image = flickrPhoto.thumbnail
            return cell
        }

        if flickrPhoto.largeImage != nil
        {
            cell.imageView.image    = flickrPhoto.largeImage
            return cell
        }

        cell.imageView.image    = flickrPhoto.thumbnail
        cell.activityIndicator.startAnimating()

        flickrPhoto.loadLargeImage{
            loadedFlickrPhoto, error in

            cell.activityIndicator.stopAnimating()

            if error != nil
            {
                return
            }

            if loadedFlickrPhoto.largeImage == nil
            {
                return
            }

            if indexPath == self.largePhotoIndexPath
            {
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? FlickrPhotoCell // Optional chaining
                {
                    cell.imageView.image    = loadedFlickrPhoto.largeImage
                }
            }
        }

        cell.cellLayerSetup()
        return cell
    }



    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        switch kind
        {
        case UICollectionElementKindSectionHeader:

            let headerView          = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "FlickrPhotoHeaderView", forIndexPath: indexPath) as FlickrPhotoHeaderView
            headerView.label.text   = searches[indexPath.section].searchTerm
            return headerView
        default:
            assert(false, "Unexpected kind of element")
        }
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
        if (sharing)
        {
            println("Sharing turned on")
            return true
        }

        if largePhotoIndexPath  == indexPath
        {
            largePhotoIndexPath = nil
        }
        else
        {
            largePhotoIndexPath = indexPath
        }
        return false
    }



    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if sharing
        {
            let photo   = photoForIndexPath(indexPath)
            selectedPhotos.append(photo)
            updateSharedPhotoCount()
        }
    }



    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        if sharing
        {
            if let foundIndex   = find(selectedPhotos, photoForIndexPath(indexPath))
            {
                selectedPhotos.removeAtIndex(foundIndex)
                updateSharedPhotoCount()
            }
        }
    }



    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

    /*
    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let flickrPhoto = photoForIndexPath(indexPath)

        if indexPath == largePhotoIndexPath
        {
            var size    = collectionView.bounds.size
            size.height -= topLayoutGuide.length
            size.height -= (sectionInsets.top + sectionInsets.right)
            size.width  -= (sectionInsets.left + sectionInsets.right)
            return flickrPhoto.sizeToFillWidthOfSize(size)
        }

        if var size = flickrPhoto.thumbnail?.size
        {
            size.width  += 10
            size.height += 10
            return size
        }

        return CGSize(width: 100, height: 100)
    }



    private let sectionInsets   = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)



    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return sectionInsets
    }
    */


    // MARK: - UICollectionView Animation Code

}
