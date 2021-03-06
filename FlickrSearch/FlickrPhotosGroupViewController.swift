//
//  FlickrPhotosViewController.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 1/12/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//




import Foundation
import UIKit




let reuseIdentifier: String             = "FlickrCell"
let GroupTitleIdentifier: NSString      = "GroupTitle"




class FlickrPhotosGroupViewController:
    UICollectionViewController,
    UITextFieldDelegate
{
    private var searches            = [FlickrSearchResults]()
    private let flickr              = Flickr()
    private var groupPhotos         = [FlickrPhoto]()
    private let shareTextLabel      = UILabel()
    private var selectedIndexPath: NSIndexPath?
    private var lastLongPressedIndexPath: NSIndexPath?

    @IBOutlet private weak var flickrPhotosLayout: FlickrPhotosGroupViewLayout!
    @IBOutlet var longPressGestureRecognzer: UILongPressGestureRecognizer!

    var largePhotoIndexPath: NSIndexPath?
    {
        didSet
        {
            var indexPaths  = [NSIndexPath]()

            if largePhotoIndexPath != nil
            {
                //println("largePhotoIndexPath != nil: \(largePhotoIndexPath)")
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


    // MARK: - UICollectionViewController Methods

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    
    
    override func viewDidLoad()
    {
        //println("view controller viewDidLoad()")
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView?.registerClass(PFPhotosGroupTitleReusableView.self, forSupplementaryViewOfKind: PFPhotoGroupTitleKind, withReuseIdentifier: GroupTitleIdentifier as String)
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

                let sideInset: CGFloat              = UIScreen.mainScreen().preferredMode!.size.width == 1136.0 ? 45.0 : 25.0

                flickrPhotosLayout.itemInsets       = UIEdgeInsetsMake(22.0, sideInset, 13.0, sideInset)
            }
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                flickrPhotosLayout.numberOfColumns  = 3

                let sideInset: CGFloat              = UIScreen.mainScreen().preferredMode!.size.width == 1136.0 ? 45.0 : 25.0

                flickrPhotosLayout.itemInsets       = UIEdgeInsetsMake(22.0, sideInset, 13.0, sideInset)
            }
        }
        else
        {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad
            {
                flickrPhotosLayout.numberOfColumns  = 3

                let inset: CGFloat                  = flickrPhotosLayout.itemInsetValue
                flickrPhotosLayout.itemInsets       = UIEdgeInsetsMake(inset, inset, inset, inset)
            }
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                flickrPhotosLayout.numberOfColumns  = 2

                let inset: CGFloat                  = flickrPhotosLayout.itemInsetValue
                flickrPhotosLayout.itemInsets       = UIEdgeInsetsMake(inset, inset, inset, inset)
            }
        }
    }



    // MARK: - Properties

    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto
    {
        return searches[indexPath.section].searchResults[indexPath.row]
    }



    func groupPhotosForIndexPath(indexPath: NSIndexPath) -> [FlickrPhoto]
    {
        return searches[indexPath.section].searchResults
    }



    func largePhotoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto
    {
        largePhotoIndexPath     = indexPath
        return searches[largePhotoIndexPath!.section].searchResults[largePhotoIndexPath!.row]
    }
    
    
    
    func largeGroupPhotosForIndexPath(indexPath: NSIndexPath) -> [FlickrPhoto]
    {
        largePhotoIndexPath     = indexPath
        return searches[largePhotoIndexPath!.section].searchResults
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

            if sharing && largePhotoIndexPath != nil
            {
                largePhotoIndexPath     = nil
            }

            let shareButton = self.navigationItem.rightBarButtonItems!.first! as UIBarButtonItem

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

        if !groupPhotos.isEmpty
        {
            var imageArray      = [UIImage]()
            for photo in self.groupPhotos
            {
                imageArray.append(photo.thumbnail!)
            }

            let shareScreen     = UIActivityViewController(activityItems: imageArray, applicationActivities: nil)
            let popover         = UIPopoverController(contentViewController: shareScreen)
            popover.presentPopoverFromBarButtonItem(self.navigationItem.rightBarButtonItems!.first! as UIBarButtonItem, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }

        sharing = !sharing
    }




    // MARK: - Text Field Delegate Methods

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        let activityIndicator   = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        flickr.searchFlickrForTerm(textField.text!)
        {
            results, error in

            //println("results: \(results)")

            activityIndicator.removeFromSuperview()
            if error != nil
            {
                //println("Error Searching : \(error)")
                let errorAlert  = UIAlertView(title: "Oops!", message: "The Internet connection appears to be offline.", delegate: self, cancelButtonTitle: "Ok")
                errorAlert.show()
            }

            if results != nil
            {
                //println("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
                self.searches.insert(results!, atIndex: 0)

                self.collectionView?.reloadData()
            }

            if results == nil && error == nil
            {
                let errorAlert  = UIAlertView(title: "Oops!", message: "Your search resulted in no photos. Please try searching again. Thanks.", delegate: self, cancelButtonTitle: "Ok")
                errorAlert.show()
            }
        }

        textField.text  = nil
        textField.resignFirstResponder()
        return true
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "photosDetailSegue"
        {
            let controller: FlickrPhotosDetailViewController    = segue.destinationViewController as! FlickrPhotosDetailViewController
            
            if let groupIndexPathWithSection = selectedIndexPath?.section
            {
                controller.selectedPhotos               = searches[groupIndexPathWithSection].searchResults
                controller.selectedPhotosTitle          = searches[groupIndexPathWithSection].searchTerm
            }
        }
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrPhotosGroupCell

        var photoCount      = searches[indexPath.section].searchResults.count
        if photoCount > 3
        {
            photoCount  = 3
        }

        let flickrPhoto         = photoForIndexPath(indexPath)
        cell.imageView.image    = flickrPhoto.thumbnail
        cell.cellLayerSetup()
        
        return cell
    }



    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        let titleView               = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: GroupTitleIdentifier as String, forIndexPath: indexPath) as! PFPhotosGroupTitleReusableView
        titleView.titleLabel.text   = searches[indexPath.section].searchTerm

        return titleView
    }

    

    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        selectedIndexPath           = indexPath

        return true
    }



    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        selectedIndexPath           = indexPath

        self.performSegueWithIdentifier("photosDetailSegue", sender: self)

        /*
        if sharing
        {
            let photos  = groupPhotosForIndexPath(indexPath)
            groupPhotos.append(photo)
            updateSharedPhotoCount()
        }
        */
    }



    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        if sharing
        {
            if let foundIndex   = groupPhotos.indexOf(photoForIndexPath(indexPath))
            {
                groupPhotos.removeAtIndex(foundIndex)
                updateSharedPhotoCount()
            }
        }
    }



    // MARK: - UIViewController Overrides

    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool
    {
        //println("canPerformAction")

        // Make sure the menu controller lets the responder chain know that it can handle its own
        // custom menu action.
        if action == Selector("menuAction:")
        {
            return true
        }

        return super.canPerformAction(action, withSender: sender)
    }



    override func canBecomeFirstResponder() -> Bool
    {
        //println("override canBecomeFirstResponder")
        return true
    }



    // MARK: - UIGestures

    @IBAction func handleLongPress(recognizer: UILongPressGestureRecognizer)
    {
        if recognizer.state != UIGestureRecognizerState.Began
        {
            return
        }

        // Grab the location of the gesture and use it to locate the cell it was made on.
        let selectedPoint: CGPoint      = recognizer.locationInView(self.collectionView)

        var indexPath: NSIndexPath?
        indexPath                       = collectionView?.indexPathForItemAtPoint(selectedPoint)

        // Check to make sure the long press was performed on a cell and not elsewhere.
        if let index = indexPath
        {
            // Update the instance variable for func menuAction()
            lastLongPressedIndexPath        = index

            // Grab the cell from which to display the menu controller.
            let selectedCell: UICollectionViewCell  = self.collectionView!.cellForItemAtIndexPath(index)!


            //
            // Create a custom menu item
            //
            // Custom menu with Delete and Cut items
            let deleteMenuItem: UIMenuItem  = UIMenuItem(title: "Delete", action: "deletePhotoGroup:")
            //var renameMenuItem: UIMenuItem  = UIMenuItem(title: "Rename", action: Selector("renamePhotoGroup:"))


            //
            // Menu Controller
            //
            // Configure the shared menu controller and display it.
            let menuController: UIMenuController    = UIMenuController.sharedMenuController()

            // Menu controller for Delete and Cut items
            menuController.menuItems        = [deleteMenuItem]
            //menuController.menuItems        = [deleteMenuItem, renameMenuItem]

            self.becomeFirstResponder()
            menuController.setTargetRect(selectedCell.bounds, inView: selectedCell)

            // Configure look of menu controller
            menuController.arrowDirection   = .Down

            menuController.setMenuVisible(true, animated: true)
        }
        else
        {
            return
        }
    }



    func deletePhotoGroup(sender: AnyObject)
    {
        //println("deletePhotoGroup:")

        // Grab the last long-ressed index path and use it to find its corresponding model
        if let index = lastLongPressedIndexPath
        {
            //let indexSet = NSMutableIndexSet()

            self.collectionView?.performBatchUpdates(
                {
                    //
                    // 1. Delete the photo section.
                    //    ELSE: Find out how many photos there are for the section that I am going to delete
                    self.searches.removeAtIndex(index.section)


                    //
                    // 2. Delete the section in the collection view
                    //
                    self.collectionView?.deleteSections(NSIndexSet(index: index.section))

                    return
                }){
                    completed in

                    return
            }
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: End of FlickrPhotosGroupViewController
}
