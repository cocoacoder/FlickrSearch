//
//  FlickrPhotoCell.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 1/14/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//




import UIKit
import QuartzCore




class FlickrPhotosGroupCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!



    required init(coder aDecoder: NSCoder)
    {
        var altSelectedBackgroundView: PFHouseWorksCustomCellSelectedBackground     = PFHouseWorksCustomCellSelectedBackground(frame: CGRect(x: 0, y: 0, width:300 , height: 300))

        super.init(coder: aDecoder)
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
        //println("Calling cellLayerSetup")

        self.layer.masksToBounds        = true
        self.layer.borderColor          = UIColor.whiteColor().CGColor
        self.layer.borderWidth          = 1.0
        self.layer.shouldRasterize      = true
    }
}
