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
        interItemSpacingY   = 2.0
        numberOfColumns     = 3
    }



    override func prepareLayout()
    {
        println("\n\nCalling layout prepareLayout()")

        var newLayoutInfo: NSMutableDictionary  = NSMutableDictionary()
        var cellLayoutInfo: NSMutableDictionary = NSMutableDictionary()

        if var sections = collectionView?.numberOfSections()
        {
            var sectionCount: Int                   = sections
            println("sectionCount = \(sectionCount)")

            var indexPath: NSIndexPath              = NSIndexPath(forItem: 0, inSection: 0)
            println("indexPath = \(indexPath)")

            var section: Int

            for section in 0..<sectionCount
            {
                println("Section: \(section)")

                if var items: Int   = collectionView?.numberOfItemsInSection(section)
                {
                    println("items: \(items)")

                    for item in 0..<items
                    {
                        println("item: \(item)")
                        
                        indexPath   = NSIndexPath(forItem: item, inSection: section)
                        println("indexPath: \(indexPath)")

                        var itemAttributes: UICollectionViewLayoutAttributes
                        itemAttributes              = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                        itemAttributes.frame        = self.frameForFlickrPhotoAtIndexPath(indexPath)

                        cellLayoutInfo[indexPath]   = itemAttributes
                        //println("cellLayoutInfo: \(cellLayoutInfo) for indexPath: \(indexPath)")
                    }
                }
                else
                {
                    var alertView   = UIAlertView(title: "Oops!", message: "No items in your section", delegate: self, cancelButtonTitle: "Ok")
                    alertView.show()
                }
            }
        }
        else
        {
            var alertView   = UIAlertView(title: "Oops!", message: "No sections in your collection", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
        }

        newLayoutInfo[PFFlickrPhotoCellKind]    = cellLayoutInfo

        layoutInfo      = newLayoutInfo
        //println("layoutInfo.count = \(layoutInfo.count)")
    }



    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]?
    {
        println("\n\nCalling layout layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]?")

        //println("UIScreen.mainScreen().bounds: \(UIScreen.mainScreen().bounds)")

        //println("layoutInfo.count = \(layoutInfo.count)")
        let allAttributes: NSMutableArray       = NSMutableArray(capacity: layoutInfo.count)

        layoutInfo.enumerateKeysAndObjectsUsingBlock({ (elementID, elementsInfo, stopBool) -> Void in
            var myKey = elementID as? NSString

            if var myObj = elementsInfo as? NSDictionary
            {
                //println("You've got elements!")

                myObj.enumerateKeysAndObjectsUsingBlock({ (indexPath, attributes, innerStop) -> Void in
                    var myObjIndexPath  = indexPath as? NSIndexPath
                    var myObjAttributes = attributes as? UICollectionViewLayoutAttributes

                    //println("attributes: \(attributes)")
                    //println("myObjAttributes: \(myObjAttributes)")
                    //println("rect: \(rect)")
                    //println("myObjAttributes.frame: \(attributes.frame)")

                    if var myAttributes = myObjAttributes
                    {
                        //println("myAttributes: \(myAttributes)")
                        //println("rect: \(rect)")
                        //println("myAttributes.frame: \(myAttributes.frame)")

                        var myRect: CGRect  = CGRectMake(rect.origin.x, rect.origin.y, rect.width, rect.height)
                        if myRect.origin.y < 0
                        {
                            var faultyOriginY   = myRect.origin.y
                            var newRect: CGRect = CGRectMake(0.0, 0.0, -faultyOriginY, myRect.height)
                            myRect              = newRect
                        }

                        //println("myRect: \(myRect)")
                        //println("myAttributes.frame: \(myAttributes.frame)")

                        if CGRectIntersectsRect(myRect, myAttributes.frame) // Oops, in simulator rect is (0.0,-1024.0,0.0,2048.0), which is weird.
                        {
                            //println("You've got attributes")
                            //println("myAttributes: \(myObjAttributes)")
                            allAttributes.addObject(myAttributes)
                        }
                        else
                        {
                            var alertView   = UIAlertView(title: "Oops!", message: "No attributes are available", delegate: self, cancelButtonTitle: "Ok")
                            alertView.show()
                            println("Ummm...you have no attributes, dude.")
                        }
                    }
                })
            }
            else
            {
                println("Ummm...you've got no elements, dude.")
                var alertView   = UIAlertView(title: "Oops!", message: "No elements are available", delegate: self, cancelButtonTitle: "Ok")
                alertView.show()
            }
        })

        let attributesArray    = allAttributes as Array
        //println("Attributes array = \(attributesArray)")

        return allAttributes as Array
    }



    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes!
    {
        println("\n\nCalling layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes!\n\n")

        //var aDict: NSDictionary     = layoutInfo[PFFlickrPhotoCellKind] as NSDictionary
        //println("aDict: \(aDict)")

        //var attributes: UICollectionViewLayoutAttributes
        //attributes                  = aDict[indexPath] as UICollectionViewLayoutAttributes
        //println("attributes: \(attributes)")

        // A shorter way to do this that mimic the Obj-C layoutInfo[PFFlickrPhotoCellKind][indexPath]
        var attributes:UICollectionViewLayoutAttributes    = (layoutInfo[PFFlickrPhotoCellKind] as NSDictionary)[indexPath] as UICollectionViewLayoutAttributes
        //println("attributes2: \(attributes2)")

        return attributes
    }



    override func collectionViewContentSize() -> CGSize
    {
        var height: CGFloat

        if var aCollectionView = collectionView?
        {
            if var rowCount = collectionView?.numberOfSections()
            {
                if rowCount % numberOfColumns > 0
                {
                    rowCount++
                }

                var edgeSpacing: CGFloat    = edgeInsets.top + edgeInsets.bottom
                var interSpacing: CGFloat   = CGFloat(rowCount) + itemSize.height + CGFloat(rowCount - 1) * CGFloat(interItemSpacingY)

                height                      = edgeSpacing + interSpacing

                //return CGSizeMake(aCollectionView.bounds.size.width, height)
            }
            else
            {
                height      = 200.0

                var alertView   = UIAlertView(title: "Oops!", message: "No multi-row content", delegate: self, cancelButtonTitle: "Ok")
                alertView.show()
                println("Ummm...you have no rows, dude.")
                
                //return CGSizeMake(200.00, 200.00)
            }

            return CGSizeMake(aCollectionView.bounds.size.width, height)
        }
        else
        {
            var alertView   = UIAlertView(title: "Oops!", message: "No content", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
            println("Ummm...you have no content, dude.")

            return CGSizeMake(200.00, 200.00)
        }
    }



    // MARK: - Private Methods

    private func frameForFlickrPhotoAtIndexPath(indexPath: NSIndexPath) -> CGRect
    {
        println("\n\nCalling layout frameForFlickrPhotoAtIndexPath(indexPath: NSIndexPath)–>CGRect")

        var row: Int        = (indexPath.section / numberOfColumns)
        var column: Int     = indexPath.section % numberOfColumns

        //println("indexPath: \(indexPath)")
        println("indexPath.section = \(indexPath.section)")
        println("column = \(column)")

        println("itemSize.width = \(itemSize.width)")
        var itemSizeWidth   = Float(itemSize.width)
        var columnSpacing   = numberOfColumns * Int(itemSizeWidth)

        var originX: CGFloat    = 0.0
        var originY: CGFloat    = 0.0

        if var sizeWidth = collectionView?.bounds.size.width
        {
            var itemWidth       = CGFloat(numberOfColumns) * itemSize.width
            var spacingX        = sizeWidth - edgeInsets.left - edgeInsets.right - itemWidth

            if self.numberOfColumns > 1
            {
                spacingX            = spacingX / (CGFloat(numberOfColumns - 1))
            }

            originX         = CGFloat(floorf(Float(edgeInsets.left) + Float(itemSize.width + spacingX) * Float(column)))
            originY         = CGFloat(floorf(Float(edgeInsets.top) + Float(itemSize.height + interItemSpacingY) * Float(row)))

            println("originX = \(originX)")
            println("originY = \(originY)")
        }
        else
        {
            var alertView   = UIAlertView(title: "Oops!", message: "Collections are not available", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
        }
        
        return CGRectMake(originX, originY, itemSize.width, itemSize.height)
    }
}
