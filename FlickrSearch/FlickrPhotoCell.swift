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
        super.init(coder: aDecoder)
    }



    override init(frame: CGRect)
    {
        super.init(frame: frame)
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
            self.cellBackgroundView.backgroundColor    = selected ? themeColor : UIColor(white: 1.0, alpha: 1.0)
        }
    }



    func cellLayerSetup() -> Void
    {
        self.layer.masksToBounds        = true
        self.layer.shouldRasterize      = true

        self.cellBackgroundView.layer.backgroundColor   = UIColor.whiteColor().CGColor
        self.cellBackgroundView.layer.shadowRadius      = 2.0
        self.cellBackgroundView.layer.shadowOffset      = CGSizeMake(1.0, 2.0)
        self.cellBackgroundView.layer.shadowOpacity     = 0.7
        self.cellBackgroundView.layer.shouldRasterize   = true

        /*
        self.imageView.layer.borderWidth                = 10.0
        self.imageView.layer.borderColor                = UIColor.whiteColor().CGColor
        self.imageView.layer.shouldRasterize            = true
        */
    }
}
