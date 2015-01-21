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
    // MARK: - Properties

    var itemInsetValue: CGFloat             = CGFloat()
    private var layoutInfo: NSDictionary    = NSDictionary()

    var itemInsets: UIEdgeInsets = UIEdgeInsetsZero
        /*{
            willSet(newInsets)
            {
                //println("About to set itemInsets to \(newInsets)")
        }
        didSet
        {
            println("self.invalidateLayout()")
            self.invalidateLayout()
        }
    }*/


    var itemSize: CGSize                    = CGSize()
        {
            willSet(newItemSize)
            {
                println("Setting itemSize")
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
            println("self.invalidateLayout()")
            self.invalidateLayout()
        }
    }



    // MARK: - Initializer

    override init()
    {
        println("Calling layout init method")

        super.init()

        self.setup()
    }



    required init(coder aDecoder: NSCoder)
    {
        println("Calling layout init method")

        self.itemInsets     = UIEdgeInsetsZero

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

        itemInsetValue      = 10.0
        itemInsets          = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        itemSize            = CGSizeMake(200.0, 200.0)
        interItemSpacingY   = 2.0
        numberOfColumns     = 2
    }



    // MARK: - Layout Methods

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

            var section: Int

            for section in 0..<sectionCount
            {
                //println("Section: \(section)")

                if var items: Int   = collectionView?.numberOfItemsInSection(section)
                {
                    //println("items: \(items)")

                    for item in 0..<items
                    {
                        //println("item: \(item)")
                        
                        indexPath   = NSIndexPath(forItem: item, inSection: section)
                        //println("indexPath: \(indexPath)")

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
    }



    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]?
    {
        println("\n\nCalling layout layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]?")

        //println("rect: \(rect)")


        //
        // So, why am I doing all of this. Well, that's an interesting story. You see, rect was getting
        // passed-in with values like (0.0,-768.0,1024.0,1536.0) or (0.0,-1024.0, 0.0,1536.0). Talk about
        // screwing things up!
        //
        var updatedRect: CGRect         = rect

        if var view = collectionView?
        {
            //println("collectionView.frame: \(view.frame)")
            //println("collectionView.bounds: \(view.bounds)")

            //var rectScale: CGFloat      = UIScreen.mainScreen().scale
            var newRect: CGRect         = view.frame
            //newRect.size.width          = newRect.size.width * rectScale
            //newRect.size.height         = newRect.size.height * rectScale

            updatedRect                 = newRect
            //println("updatedRect: \(updatedRect)")
        }
        else
        {
            var alertView   = UIAlertView(title: "Oops!", message: "There is no collection view with which to work.", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
            assert(false, "There is no collection view with which to work.")
        }

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
                        //println("myAttributes.frame: \(myAttributes.frame)")

                        if CGRectIntersectsRect(updatedRect, myAttributes.frame) // Oops, in simulator rect is (0.0,-1024.0,0.0,2048.0), which is weird.
                        {
                            //println("You've got attributes")
                            //println("myAttributes: \(myObjAttributes)")
                            allAttributes.addObject(myAttributes)
                        }
                        else
                        {
                            //var alertView   = UIAlertView(title: "Oops!", message: "No attributes are available", delegate: self, cancelButtonTitle: "Ok")
                            //alertView.show()
                            //println("Ummm...you have no attributes, dude.")

                            assert(false, "Ummm...you have no attributes, dude.")
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

                var edgeSpacing: CGFloat    = itemInsets.top + itemInsets.bottom
                var interSpacing: CGFloat   = CGFloat(rowCount) + itemSize.height + CGFloat(rowCount - 1) * CGFloat(interItemSpacingY)

                height                      = edgeSpacing + interSpacing
            }
            else
            {
                height      = 200.0

                var alertView   = UIAlertView(title: "Oops!", message: "No multi-row content", delegate: self, cancelButtonTitle: "Ok")
                alertView.show()
                //println("Ummm...you have no rows, dude.")
            }

            return CGSizeMake(aCollectionView.bounds.size.width, height)
        }
        else
        {
            var alertView   = UIAlertView(title: "Oops!", message: "No content", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
            //println("Ummm...you have no content, dude.")

            return CGSizeMake(200.00, 200.00)
        }
    }



    // MARK: - Private Methods

    private func frameForFlickrPhotoAtIndexPath(indexPath: NSIndexPath) -> CGRect
    {
        //println("\n\nCalling layout frameForFlickrPhotoAtIndexPath(indexPath: NSIndexPath)–>CGRect")

        var row: Int        = (indexPath.section / numberOfColumns)
        var column: Int     = indexPath.section % numberOfColumns

        //println("indexPath: \(indexPath)")
        //println("indexPath.section = \(indexPath.section)")
        //println("column = \(column)")

        //println("itemSize.width = \(itemSize.width)")
        var itemSizeWidth   = Float(itemSize.width)
        var columnSpacing   = numberOfColumns * Int(itemSizeWidth)

        var originX: CGFloat    = 0.0
        var originY: CGFloat    = 0.0

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

            //println("originX = \(originX)")
            //println("originY = \(originY)")
        }
        else
        {
            var alertView   = UIAlertView(title: "Oops!", message: "Collections are not available", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
        }
        
        return CGRectMake(originX, originY, itemSize.width, itemSize.height)
    }
}
