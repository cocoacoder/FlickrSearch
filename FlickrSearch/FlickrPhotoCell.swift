//
//  FlickrPhotoCell.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 3/2/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//




import UIKit
import QuartzCore




class FlickrPhotoCell: UICollectionViewCell
{
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!



    required init(coder aDecoder: NSCoder)
    {
        println("Calling initWithCoder")

        //var altSelectedBackgroundView: PFHouseWorksCustomCellSelectedBackground     = PFHouseWorksCustomCellSelectedBackground(frame: CGRect(x: 0, y: 0, width:300 , height: 300))

        super.init(coder: aDecoder)

        self.layer.borderColor          = UIColor.whiteColor().CGColor
        /*
        self.cellBackgroundView.layer.backgroundColor   = UIColor.whiteColor().CGColor
        self.cellBackgroundView.layer.borderWidth       = 1.0
        self.cellBackgroundView.layer.shadowColor       = UIColor.blackColor().CGColor
        self.cellBackgroundView.layer.shadowRadius      = 3.0
        self.cellBackgroundView.layer.shadowOffset      = CGSizeMake(0.0, 3.0)
        self.cellBackgroundView.layer.shadowOpacity     = 0.9
        self.cellBackgroundView.layer.shouldRasterize   = true
        */
    }



    override init(frame: CGRect)
    {
        println("Calling initWithFrame: \(frame)")

        super.init(frame: frame)

        //self.backgroundColor            = UIColor(white: 0.85, alpha: 1.0)
        self.layer.borderColor          = UIColor.whiteColor().CGColor

        self.cellBackgroundView.layer.backgroundColor   = UIColor.whiteColor().CGColor
        self.cellBackgroundView.layer.borderWidth       = 1.0
        self.cellBackgroundView.layer.shadowColor       = UIColor.blackColor().CGColor
        self.cellBackgroundView.layer.shadowRadius      = 3.0
        self.cellBackgroundView.layer.shadowOffset      = CGSizeMake(0.0, 3.0)
        self.cellBackgroundView.layer.shadowOpacity     = 0.9
        self.cellBackgroundView.layer.shouldRasterize   = true
    }



    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.selected   = false
    }



    override func prepareForReuse()
    {
        super.prepareForReuse()

        imageView.image     = nil
    }



    override var selected: Bool
        {
        didSet
        {
            self.backgroundColor    = selected ? themeColor : UIColor(white: 1.0, alpha: 1.0)
        }
    }



    func cellLayerSetup() -> Void
    {
        println("Calling cellLayerSetup")

        //self.backgroundColor            = UIColor(white: 0.85, alpha: 1.0)

        self.layer.masksToBounds        = true
        self.layer.borderColor          = UIColor.whiteColor().CGColor
        self.layer.borderWidth          = 1.0

        self.cellBackgroundView.layer.backgroundColor   = UIColor.whiteColor().CGColor
        self.cellBackgroundView.layer.borderWidth       = 1.0
        self.cellBackgroundView.layer.shadowColor       = UIColor.blackColor().CGColor
        self.cellBackgroundView.layer.shadowRadius      = 3.0
        self.cellBackgroundView.layer.shadowOffset      = CGSizeMake(0.0, 3.0)
        self.cellBackgroundView.layer.shadowOpacity     = 0.9
        self.cellBackgroundView.layer.shouldRasterize   = true
    }
}
