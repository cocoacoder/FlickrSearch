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

    //let flickrPhotoDetailCell               = "FlickrPhotoCell"

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
    required init(coder aDecoder: NSCoder)
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
        itemInsets          = UIEdgeInsetsMake(15.0, 10.0, 15.0, 10.0)
        interItemSpacingY   = 35.0

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            itemSize            = CGSizeMake(200.0, 230.0)

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
            itemSize            = CGSizeMake(150.0, 180.0)

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
        var newLayoutInfo: NSMutableDictionary  = NSMutableDictionary()
        var cellLayoutInfo: NSMutableDictionary = NSMutableDictionary()

        if var sections = collectionView?.numberOfSections()
        {
            var sectionCount: Int                   = sections

            var indexPath: NSIndexPath              = NSIndexPath(forItem: 0, inSection: 0)

            var section: Int

            for section in 0..<sectionCount
            {
                if var items: Int   = collectionView?.numberOfItemsInSection(section)
                {
                    if items != 0
                    {
                        for item in 0..<items
                        {
                            indexPath   = NSIndexPath(forItem: item, inSection: section)

                            var itemAttributes: UICollectionViewLayoutAttributes
                            itemAttributes              = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                            itemAttributes.frame        = self.frameForFlickrPhotoAtIndexPath(indexPath)
                            itemAttributes.transform3D  = self.transform3DForPhotoAtIndex(indexPath)
                            //itemAttributes.transform    = self.transformAffineForGroupPhotoAtIndex(indexPath)
                            itemAttributes.zIndex       = indexPath.row

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
                    var alertView   = UIAlertView(title: "Oops!", message: "There are no items in your section.", delegate: self, cancelButtonTitle: "Ok")
                    alertView.show()
                }
            }
        }
        else
        {
            var alertView   = UIAlertView(title: "Oops!", message: "There are no sections in your collection.", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
        }
        
        //newLayoutInfo[flickrPhotoDetailCell]    = cellLayoutInfo
        newLayoutInfo[detailReuseIdentifier]    = cellLayoutInfo
        
        layoutInfo      = newLayoutInfo
    }



    // MARK: - Private Methods

    func transform3DForPhotoAtIndex(indexPath: NSIndexPath) -> CATransform3D
    {
        var offset  = NSInteger(indexPath.section * rotationStride + indexPath.item)

        return  rotations[offset % rotationCount].CATransform3DValue
    }



    func transformAffineForPhotoAtIndex(indexPath: NSIndexPath) -> CGAffineTransform
    {

        var offset  = Double(indexPath.row) * 8.0
        var scale   = CGFloat(0.9 + Double(indexPath.row) * 0.05)

        var transform: CGAffineTransform    = CGAffineTransformMakeTranslation(CGFloat(0.0), CGFloat(offset))
        transform      = CGAffineTransformScale(transform, scale, scale)
        
        return transform
    }



    private func frameForFlickrPhotoAtIndexPath(indexPath: NSIndexPath) -> CGRect
    {
        var row: Int        = (indexPath.section / numberOfColumns)
        var column: Int     = indexPath.section % numberOfColumns

        var itemSizeWidth   = Float(itemSize.width)
        var columnSpacing   = numberOfColumns * Int(itemSizeWidth)

        var originX: CGFloat
        var originY: CGFloat

        if var sizeWidth = collectionView?.bounds.size.width
        {
            var itemWidth       = CGFloat(numberOfColumns) * itemSize.width
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
            var alertView   = UIAlertView(title: "Oops!", message: "Collections are not available", delegate: self, cancelButtonTitle: "Ok")
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
        var cellRotations: NSMutableArray  = NSMutableArray(capacity: rotationCount)

        var percentage: Double  = 0.0

        for i: Int in 0..<rotationCount
        {
            var newPercentage: Double = 0.0
            var deltaPercentage: Double

            do
            {
                newPercentage       = ((Double(arc4random()) % 220.0) - 110.0) * 0.0001

                deltaPercentage     = percentage - newPercentage
                deltaPercentage     = fabs(deltaPercentage)

            } while deltaPercentage < 0.01

            percentage      = newPercentage

            var angle       = CGFloat(2.0 * M_PI * (1.0 + percentage))

            var transform: CATransform3D
            transform       = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)

            cellRotations.addObject(NSValue(CATransform3D: transform))
        }
        
        rotations   = cellRotations
    }
}
