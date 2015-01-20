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



    override init()
    {
        println("Calling layout init method")
        self.edgeInsets         = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)

        super.init()

        self.setup()
    }



    required init(coder aDecoder: NSCoder)
    {
        println("Calling layout init method")

        self.edgeInsets     = UIEdgeInsetsZero

        super.init(coder: aDecoder)

        self.setup()
    }



    /*
    override func awakeFromNib()
    {
        println("Calling layout awakeFromNib")
        super.awakeFromNib()
    }
    */


    func setup()
    {
        println("\n\nCalling layout setup()")

        edgeInsets          = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        itemSize            = CGSizeMake(200.0, 200.0)
        interItemSpacingY   = 12.0
        numberOfColumns     = 2
    }



    override func prepareLayout()
    {
        println("\n\nCalling layout prepareLayout()")

        var newLayoutInfo: NSMutableDictionary  = NSMutableDictionary()
        var cellLayoutInfo: NSMutableDictionary = NSMutableDictionary()

        if var sections = collectionView?.numberOfSections()
        {
            var sectionCount: Int                   = sections
            //println("sectionCount = \(sectionCount)")

            var indexPath: NSIndexPath              = NSIndexPath(forItem: 0, inSection: 0)
            //println("indexPath = \(indexPath)")

            for var section: Int = 0; section < sectionCount; section++
            {
                println("Number of items in section: \(collectionView?.numberOfItemsInSection(section))")
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

        layoutInfo      = newLayoutInfo
        println("Here's what the layout looks like: \(layoutInfo as Dictionary)")
    }



    // MARK: - Private Methods

    private func frameForFlickrPhotoAtIndexPath(indexPath: NSIndexPath) -> CGRect
    {
        println("\n\nCalling layout frameForFlickrPhotoAtIndexPath(indexPath: NSIndexPath)–>CGRect")

        var row: Int        = (indexPath.section / numberOfColumns)
        var column: Int     = indexPath.section % numberOfColumns

        println("itemSize.width = \(itemSize.width)")
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
        println(CGRectMake(originX, originY, itemSize.width, itemSize.height))

        return CGRectMake(originX, originY, itemSize.width, itemSize.height)
    }



    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]?
    {
        println("\n\nCalling layout layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]?")

        println("layoutInfo.count = \(layoutInfo.count)")
        let allAttributes: NSMutableArray       = NSMutableArray(capacity: layoutInfo.count)

        layoutInfo.enumerateKeysAndObjectsUsingBlock({ (elementID, elementsInfo, stopBool) -> Void in
            var myKey = elementID as? NSString

            if var myObj = elementsInfo as? NSDictionary
            {
                println("You've got elements!")

                myObj.enumerateKeysAndObjectsUsingBlock({ (indexPath, attributes, innerStop) -> Void in
                    var myObjIndexPath  = indexPath as? NSIndexPath
                    var myObjAttributes = attributes as? UICollectionViewLayoutAttributes

                    if var myAttributes = myObjAttributes
                    {

                        if CGRectIntersectsRect(rect, myAttributes.frame)
                        {
                            println("You've got attributes")
                            allAttributes.addObject(myAttributes)
                        }
                        else
                        {
                            var alertView   = UIAlertView(title: "Oops!", message: "No attributes are available", delegate: self, cancelButtonTitle: "Ok")
                            println("Ummm...you have no attributes, dude.")
                        }
                    }
                })
            }
            else
            {
                println("Ummm...you've got no elements, dude.")
                var alertView   = UIAlertView(title: "Oops!", message: "No elements are available", delegate: self, cancelButtonTitle: "Ok")
            }
        })

        let attributesArray    = allAttributes as Array
        println("Attributes array = \(attributesArray)")

        return allAttributes as Array
    }


    /*
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes!
    {
        println("\n\nCalling layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes!\n\n")

        //let cell                               = layoutInfo[PFFlickrPhotoCellKind] as FlickrPhotoCell
        //println("Cell.frame = \(cell.frame)")
        //let cellAttributes: UICollectionViewLayoutAttributes    = cell.indexPath
        //return layoutInfo[PFFlickrPhotoCellKind][indexPath] as UICollectionViewLayoutAttributes


        if var cell = layoutInfo[PFFlickrPhotoCellKind] as? FlickrPhotoCell
        {
            var cellAttribute   = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            println(cellAttribute)
        }


        return UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    }
    */



    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        println("\n\nCalling layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes!\n\n")

        return UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    }

}
