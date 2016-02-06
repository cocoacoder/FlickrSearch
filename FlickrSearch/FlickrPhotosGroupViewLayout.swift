//
//  FlickrPhotosViewLayout.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 1/16/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//




import UIKit
import QuartzCore





let PFPhotoGroupTitleKind: String   = "PhotoGroupTitle"




class FlickrPhotosGroupViewLayout: UICollectionViewLayout
{
    // MARK: - Properties

    // cell ID can be defined pretty much anywhere, as a VC property or, as in the FlickrPhotosDetailedViewController, as a constant.
    let flickrPhotoCellKind                 = "FlickrCell"

    private var layoutInfo: NSDictionary    = NSDictionary()
    var itemInsetValue: CGFloat             = CGFloat()

    var itemInsets: UIEdgeInsets = UIEdgeInsetsZero

    var itemSize: CGSize                    = CGSize()
    {
        willSet(newItemSize)
        {
                //println("Setting itemSize")
        }
        didSet
        {
            self.invalidateLayout()
        }
    }

    var interItemSpacingY: CGFloat          = CGFloat()

    var numberOfColumns: Int                = Int()
    {
        willSet(newColumnNumber)
        {
            //println("About to set numberOfColumns to \(newColumnNumber)")
        }
        didSet
        {
            self.invalidateLayout()
        }
    }

    var titleHeight: CGFloat                = CGFloat()



    required init?(coder aDecoder: NSCoder)
    {
        self.itemInsets     = UIEdgeInsetsZero

        super.init(coder: aDecoder)

        self.setup()
    }



    override func awakeFromNib()
    {
        super.awakeFromNib()
    }



    func setup()
    {
        itemInsetValue      = 15.0
        itemInsets          = UIEdgeInsetsMake(25.0, 10.0, 15.0, 10.0)
        interItemSpacingY   = 25.0
        titleHeight         = 30.0

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            itemSize            = CGSizeMake(200.0, 200.0)

            if UIDevice.currentDevice().orientation == .Portrait
            {
                numberOfColumns     = 3
            }
            else
            {
                numberOfColumns     = 4
            }
        }
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            itemSize            = CGSizeMake(150.0, 150.0)

            if UIDevice.currentDevice().orientation == .Portrait
            {
                numberOfColumns     = 2
            }
            else
            {
                numberOfColumns     = 3
            }
        }
    }



    func titleHeight(newTitleHeight: CGFloat)  ->  Void
    {
        if  newTitleHeight == titleHeight
        {
            return
        }

        titleHeight     = newTitleHeight

        self.invalidateLayout()
    }



    // MARK: - Layout Methods

    override func prepareLayout()
    {
        let newLayoutInfo: NSMutableDictionary      = NSMutableDictionary()
        let cellLayoutInfo: NSMutableDictionary     = NSMutableDictionary()
        let titleLayoutInfo: NSMutableDictionary    = NSMutableDictionary()

        let baseCellZIndex  = 20

        if let sections = collectionView?.numberOfSections()
        {
            let sectionCount: Int                   = sections

            var indexPath: NSIndexPath              = NSIndexPath(forItem: 0, inSection: 0)

            //var section: Int

            for section in 0..<sectionCount
            {
                if let items: Int   = collectionView?.numberOfItemsInSection(section)
                {
                    if items != 0
                    {
                        for item in 0..<items
                        {
                            indexPath   = NSIndexPath(forItem: item, inSection: section)

                            var itemAttributes: UICollectionViewLayoutAttributes
                            itemAttributes              = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                            itemAttributes.frame        = self.frameForPhotoGroupAtIndexPath(indexPath)
                            itemAttributes.transform    = self.transformAffineForGroupPhotoAtIndex(indexPath)
                            itemAttributes.zIndex       = baseCellZIndex - indexPath.row

                            cellLayoutInfo[indexPath]   = itemAttributes

                            if indexPath.item == 0
                            {
                                let titleAttributes         = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: PFPhotoGroupTitleKind, withIndexPath: indexPath)
                                titleAttributes.frame       = self.frameForPhotoGroupTitleAtIndexPath(indexPath)
                                titleLayoutInfo[indexPath]  = titleAttributes
                            }
                        }
                    }
                    else
                    {
                        return
                    }
                }
                else
                {
                    let alertView   = UIAlertView(title: "Oops!", message: "There are no items in your section.", delegate: self, cancelButtonTitle: "Ok")
                    alertView.show()
                }
            }
        }
        else
        {
            let alertView   = UIAlertView(title: "Oops!", message: "There are no sections in your collection.", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
        }

        newLayoutInfo[flickrPhotoCellKind]      = cellLayoutInfo
        newLayoutInfo[PFPhotoGroupTitleKind]    = titleLayoutInfo
        layoutInfo      = newLayoutInfo
    }



    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        //
        // So, why am I doing all of this. Well, that's an interesting story. You see, rect was getting
        // passed-in with values like (0.0,-768.0,1024.0,1536.0) or (0.0,-1024.0, 0.0,1536.0). Talk about
        // screwing things up!
        //
        let updatedRect: CGRect         = rect


        if let aView = collectionView
        {
            _   = aView
        }
        else
        {
            let alertView   = UIAlertView(title: "Oops!", message: "There is no collection view with which to work.", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
            //assert(false, "There is no collection view with which to work.")
        }


        let allAttributes: NSMutableArray       = NSMutableArray(capacity: layoutInfo.count)

        layoutInfo.enumerateKeysAndObjectsUsingBlock({ (elementID, elementsInfo, stopBool) -> Void in
            //var myKey = elementID as? NSString

            if let myObj = elementsInfo as? NSDictionary
            {
                myObj.enumerateKeysAndObjectsUsingBlock({ (indexPath, attributes, innerStop) -> Void in
                    //var myObjIndexPath  = indexPath as? NSIndexPath
                    let myObjAttributes = attributes as? UICollectionViewLayoutAttributes

                    if let myAttributes = myObjAttributes
                    {
                        if CGRectIntersectsRect(updatedRect, myAttributes.frame) // Oops, in simulator rect is (0.0,-1024.0,0.0,2048.0), which is weird.
                        {
                            allAttributes.addObject(myAttributes)
                        }
                        else
                        {
                            let alertView   = UIAlertView(title: "Oops!", message: "No attributes are available.", delegate: self, cancelButtonTitle: "Ok")
                            alertView.show()
                        }
                    }
                })
            }
            else
            {
                let alertView   = UIAlertView(title: "Oops!", message: "No elements are available.", delegate: self, cancelButtonTitle: "Ok")
                alertView.show()
            }
        })

        //let attributesArray    = allAttributes as Array

        return allAttributes as? Array
    }



    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
    {
        //
        // Interesting note
        //
        // In Obj-C, we would write this as follows,
        //
        // UICollectionViewLayoutAttributes *attributes = layoutInfo[flickrPhotoCellKind][indexPath]
        //
        // This is how you do the same thing in Swift...
        //
        let attributes:UICollectionViewLayoutAttributes    = (layoutInfo[flickrPhotoCellKind] as! NSDictionary)[indexPath] as! UICollectionViewLayoutAttributes

        return attributes
    }



    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
    {
        return (layoutInfo[PFPhotoGroupTitleKind] as! NSDictionary)[indexPath] as? UICollectionViewLayoutAttributes
    }



    override func collectionViewContentSize() -> CGSize
    {
        var height: CGFloat

        if let aCollectionView = collectionView
        {
            if let rowItems = collectionView?.numberOfSections()
            {
                var rowCount    = rowItems / numberOfColumns

                if rowItems % numberOfColumns > 0
                {
                    rowCount += 1
                }

                let topBottomSpacing: CGFloat   = itemInsets.top + itemInsets.bottom
                let interSpacing: CGFloat       = CGFloat(rowCount) * itemSize.height + CGFloat(rowCount - 1) * CGFloat(interItemSpacingY)
                let interTitleSpacing: CGFloat  = CGFloat(rowCount) * titleHeight

                height                          = topBottomSpacing + interSpacing + interTitleSpacing

                //println("collectionView height/width: = \(height), \(aCollectionView.bounds.size.width)")
                return CGSizeMake(aCollectionView.bounds.size.width, height)
            }

            else
            {
                let alertView   = UIAlertView(title: "Oops!", message: "There is no multi-row content to display.", delegate: self, cancelButtonTitle: "Ok")
                alertView.show()
                print("Ummm...you have no rows, dude.")

                return CGSizeZero
            }
        }

        else
        {
            let alertView   = UIAlertView(title: "Oops!", message: "There is no content to display.", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()

            return CGSizeZero
        }
    }



    // MARK: - Private Methods

    func transformAffineForGroupPhotoAtIndex(indexPath: NSIndexPath) -> CGAffineTransform
    {

        let offset  = Double(-indexPath.row) * 8.0
        let scale   = CGFloat(1.0 - Double(indexPath.row) * 0.05)

        var transform: CGAffineTransform    = CGAffineTransformMakeTranslation(CGFloat(0.0), CGFloat(offset))
        transform      = CGAffineTransformScale(transform, scale, scale)
        
        return transform
    }
    
    
    
    private func frameForPhotoGroupAtIndexPath(indexPath: NSIndexPath) -> CGRect
    {
        let row: Int        = indexPath.section / numberOfColumns
        let column: Int     = indexPath.section % numberOfColumns

        //let itemSizeWidth   = Float(itemSize.width)
        //var columnSpacing   = numberOfColumns * Int(itemSizeWidth)

        var originX: CGFloat
        var originY: CGFloat

        if let sizeWidth = collectionView?.bounds.size.width
        {
            let itemWidth       = CGFloat(numberOfColumns) * itemSize.width
            var spacingX        = sizeWidth - itemInsets.left - itemInsets.right - itemWidth

            if self.numberOfColumns > 1
            {
                spacingX            = spacingX / (CGFloat(numberOfColumns - 1))
            }

            

            originX         = CGFloat(floorf(Float(itemInsets.left) + Float(itemSize.width + spacingX) * Float(column)))
            originY         = CGFloat(floorf(Float(itemInsets.top) + Float(itemSize.height + titleHeight + interItemSpacingY) * Float(row)))
        }
        else
        {
            let alertView   = UIAlertView(title: "Oops!", message: "Collections are not available", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()

            return CGRectZero
        }

        return CGRectMake(originX, originY, itemSize.width, itemSize.height)
    }



    private func frameForPhotoGroupTitleAtIndexPath(indexPath: NSIndexPath) -> CGRect
    {
        var frame: CGRect   = self.frameForPhotoGroupAtIndexPath(indexPath)
        frame.origin.y     += frame.size.height
        frame.size.height   = titleHeight

        return frame
    }
}
