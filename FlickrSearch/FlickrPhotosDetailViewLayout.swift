//
//  FlickrPhotosDetailViewLayout.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 3/2/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//




import UIKit




class FlickrPhotosDetailViewLayout: UICollectionViewLayout
{
    // MARK: - Properties

    let flickrPhotoDetailCell               = "FlickrPhotoCell"

    var itemInsetValue: CGFloat             = CGFloat()
    private var layoutInfo: NSDictionary    = NSDictionary()
    let rotationCount: NSInteger            = 32
    let rotationStride: NSInteger           = 3

    var rotations: NSArray                  = NSArray()

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
    /*{
    didSet
    {
    self.invalidateLayout()
    }
    }*/

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



    // MARK: - Initializer
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
        interItemSpacingY   = 35.0

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

        //
        // Default layout display of grouped items
        //
        // The default layout for how grouped items are laid-out is as a somewhat random pile of paper, photos, things, etc.
        //
        self.cellRotationsArray()
    }

    
    
    // MARK: - Layout Methods

    override func prepareLayout()
    {
        let newLayoutInfo: NSMutableDictionary  = NSMutableDictionary()
        let cellLayoutInfo: NSMutableDictionary = NSMutableDictionary()

        if let sections = collectionView?.numberOfSections()
        {

            //var sectionCount: Int                   = sections
            _                                       = sections

            var indexPath: NSIndexPath              = NSIndexPath(forItem: 0, inSection: 0)

            let section: Int                        = indexPath.section

            if let items: Int   = collectionView?.numberOfItemsInSection(section)
            {
                //println("How many photos: \(items)")
                if items != 0
                {
                    for item in 0..<items
                    {
                        //println("item: \(item)")
                        indexPath   = NSIndexPath(forItem: item, inSection: section)

                        var itemAttributes: UICollectionViewLayoutAttributes
                        itemAttributes              = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                        itemAttributes.frame        = self.frameForFlickrPhotoAtIndexPath(indexPath)
                        itemAttributes.transform3D  = self.transform3DForPhotoAtIndex(indexPath)
                        //itemAttributes.zIndex       = indexPath.row

                        cellLayoutInfo[indexPath]   = itemAttributes
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
        else
        {
            let alertView   = UIAlertView(title: "Oops!", message: "There are no sections in your collection.", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
        }
        
        newLayoutInfo[flickrPhotoDetailCell]    = cellLayoutInfo
        //newLayoutInfo[detailReuseIdentifier]    = cellLayoutInfo

        layoutInfo      = newLayoutInfo
    }



    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        //
        // So, why am I doing all of this. Well, that's an interesting story. You see, rect was getting
        // passed-in with values like (0.0,-768.0,1024.0,1536.0) or (0.0,-1024.0, 0.0,1536.0). Talk about
        // screwing things up!
        //
        let updatedRect: CGRect                 = rect

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
                            //var alertView   = UIAlertView(title: "Oops!", message: "No attributes are available.", delegate: self, cancelButtonTitle: "Ok")
                            //alertView.show()
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

        return allAttributes as? Array<UICollectionViewLayoutAttributes>
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
        let attributes:UICollectionViewLayoutAttributes    = (layoutInfo[flickrPhotoDetailCell] as! NSDictionary)[indexPath] as! UICollectionViewLayoutAttributes

        return attributes
    }



    override func collectionViewContentSize() -> CGSize
    {
        var height: CGFloat

        let indexPath: NSIndexPath              = NSIndexPath(forItem: 0, inSection: 0)

        let section: Int                        = indexPath.section

        if let aCollectionView = collectionView
        {
            if let rowItems = collectionView?.numberOfItemsInSection(section) // numberOfSections()
            {
                var rowCount    = rowItems / numberOfColumns

                if rowItems % numberOfColumns > 0
                {
                    rowCount += 1
                }

                let topBottomSpacing: CGFloat   = itemInsets.top + itemInsets.bottom
                let interSpacing: CGFloat       = CGFloat(rowCount) * itemSize.height + CGFloat(rowCount - 1) * CGFloat(interItemSpacingY)

                height                          = topBottomSpacing + interSpacing
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

    func transform3DForPhotoAtIndex(indexPath: NSIndexPath) -> CATransform3D
    {
        let offset  = NSInteger(indexPath.section * rotationStride + indexPath.item)

        return  rotations[offset % rotationCount].CATransform3DValue
    }



    func transformAffineForPhotoAtIndex(indexPath: NSIndexPath) -> CGAffineTransform
    {

        let offset  = Double(indexPath.row) * 8.0
        let scale   = CGFloat(0.9 + Double(indexPath.row) * 0.05)

        var transform: CGAffineTransform    = CGAffineTransformMakeTranslation(CGFloat(0.0), CGFloat(offset))
        transform      = CGAffineTransformScale(transform, scale, scale)
        
        return transform
    }



    private func frameForFlickrPhotoAtIndexPath(indexPath: NSIndexPath) -> CGRect
    {
        let row: Int        = (indexPath.row / numberOfColumns)
        let column: Int     = indexPath.row % numberOfColumns

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
            originY         = CGFloat(floorf(Float(itemInsets.top) + Float(itemSize.height + interItemSpacingY) * Float(row)))
        }
        else
        {
            let alertView   = UIAlertView(title: "Oops!", message: "Collections are not available", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()

            return CGRectZero
        }

        return CGRectMake(originX, originY, itemSize.width, itemSize.height)
    }
    
    
    
    private func cellRotationsArray() -> Void
    {
        //
        // Default layout display of grouped items
        //
        // The default layout for how grouped items are laid-out is as a somewhat random pile of paper, photos, things, etc.
        //
        let cellRotations: NSMutableArray  = NSMutableArray(capacity: rotationCount)

        var percentage: Double  = 0.0

        for i: Int in 0..<rotationCount
        {
            print("FlickrPhotosDetailViewLayout cellRotationsArray")
            var newPercentage: Double = 0.0
            var deltaPercentage: Double

            repeat
            {
                newPercentage       = ((Double(arc4random()) % 220.0) - 110.0) * 0.0001

                deltaPercentage     = percentage - newPercentage
                deltaPercentage     = fabs(deltaPercentage)

            } while deltaPercentage < 0.01

            percentage      = newPercentage

            let angle       = CGFloat(2.0 * M_PI * (1.0 + percentage))

            var transform: CATransform3D
            transform       = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)

            cellRotations.addObject(NSValue(CATransform3D: transform))
        }
        
        rotations   = cellRotations
    }

}
