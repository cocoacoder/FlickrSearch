//
//  FlickrPhotoCell.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 1/14/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//




import UIKit
import QuartzCore





class FlickrPhotoCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!



    required init(coder aDecoder: NSCoder)
    {
        //println("Calling cell init with coder method")

        super.init(coder: aDecoder)

        self.backgroundColor            = UIColor(white: 0.85, alpha: 1.0)

        self.layer.borderColor          = UIColor.whiteColor().CGColor
        self.layer.borderWidth          = 6.0
        self.layer.shadowColor          = UIColor.redColor().CGColor
        self.layer.shadowRadius         = 6.0
        self.layer.shadowOffset         = CGSizeMake(0.0, 3.0)
        self.layer.shadowOpacity        = 0.5
    }



    override init(frame: CGRect)
    {
        println("Calling initWithFrame: \(frame)")

        super.init(frame: frame)

        self.backgroundColor            = UIColor(white: 0.85, alpha: 1.0)
        
        self.layer.borderColor          = UIColor.whiteColor().CGColor
        self.layer.borderWidth          = 1.0
        self.layer.shadowColor          = UIColor.blackColor().CGColor
        self.layer.shadowRadius         = 10.0
        self.layer.shadowOffset         = CGSizeMake(0.0, 2.0)
        self.layer.shadowOpacity        = 0.5

    }



    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.selected   = false
    }



    override func prepareForReuse() {
        super.prepareForReuse()

        //imageView.image     = nil
    }



    override var selected: Bool
    {
        didSet
        {
            self.backgroundColor    = selected ? themeColor : UIColor.lightGrayColor()
        }
    }
}
