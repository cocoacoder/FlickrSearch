//
//  FlickrPhotosViewLayout.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 1/16/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//




import UIKit




let PFFlickrPhotoCellKind           = "FlickrCell"




class FlickrPhotosViewLayout: UICollectionViewLayout
{
    var edgeInsets: UIEdgeInsets
    var itemSize: CGSize                    = CGSize()
    var interItemSpacingY: CGFloat          = CGFloat()
    var numberOfColumns: Int                = Int()

    private var layoutInfo: NSDictionary    = NSDictionary()



    required init(coder aDecoder: NSCoder)
    {

        self.edgeInsets     = UIEdgeInsetsZero

        super.init(coder: aDecoder)

        self.setup()
    }



    func setup()
    {
        edgeInsets          = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        itemSize            = CGSizeMake(200.0, 200.0)
        interItemSpacingY   = 12.0
        numberOfColumns     = 2
    }



    override func prepareLayout()
    {
        var newLayoutInfo: NSMutableDictionary  = NSMutableDictionary()
        var cellLayoutInfo: NSMutableDictionary = NSMutableDictionary()

        if var sections = collectionView?.numberOfSections()
        {
            var sectionCount: Int                   = sections
            var indexPath: NSIndexPath              = NSIndexPath(forItem: 0, inSection: 0)

            for var section: Int = 0; section < sectionCount; section++
            {
                var itemCount   = collectionView?.numberOfItemsInSection(section)

                var itemAttributes: UICollectionViewLayoutAttributes
                itemAttributes              = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                itemAttributes.frame        = self.frameForFlickrPhotoAtIndexPath(indexPath)

                cellLayoutInfo[indexPath]   = itemAttributes
            }
        }
        else
        {
            var alertView   = UIAlertView(title: "Oops!", message: "Collections are not available", delegate: self, cancelButtonTitle: "Ok")
        }

        newLayoutInfo[PFFlickrPhotoCellKind]    = cellLayoutInfo
    }



    // MARK: - Private Methods

    private func frameForFlickrPhotoAtIndexPath(indexPath: NSIndexPath) -> CGRect
    {
        var row: Int        = (indexPath.section / numberOfColumns)
        var column: Int     = indexPath.section % numberOfColumns

        var itemSizeWidth   = Float(itemSize.width)
        var columnSpacing   = numberOfColumns * Int(itemSizeWidth)

        var originX: CGFloat    = 0.0
        var originY: CGFloat    = 0.0

        if var sizeWidth = collectionView?.bounds.size.width
        {
            var spacingX        = sizeWidth - edgeInsets.left - edgeInsets.right

            if self.numberOfColumns > 1
            {
                spacingX            = spacingX / (CGFloat(numberOfColumns) - 1.0)
            }

            originX         = CGFloat(floorf(Float(edgeInsets.left) + Float(itemSize.width + spacingX) * Float(row)))
            originY         = CGFloat(floorf(Float(edgeInsets.top) + Float(itemSize.height + interItemSpacingY) * Float(row)))
        }
        else
        {
            var alertView   = UIAlertView(title: "Oops!", message: "Collections are not available", delegate: self, cancelButtonTitle: "Ok")
        }


        return CGRectMake(originX, originY, itemSize.width, itemSize.height)
    }
}
