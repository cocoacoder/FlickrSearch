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
    @IBOutlet weak var groupLabel: UILabel!



    required init(coder aDecoder: NSCoder)
    {
        //println("Calling cell init with coder method")

        var altSelectedBackgroundView: PFHouseWorksCustomCellSelectedBackground     = PFHouseWorksCustomCellSelectedBackground(frame: CGRect(x: 0, y: 0, width:300 , height: 300))

        super.init(coder: aDecoder)

        self.backgroundColor            = UIColor(white: 0.85, alpha: 1.0)

        self.layer.borderColor          = UIColor.whiteColor().CGColor
        self.layer.borderWidth          = 1.0
        self.layer.shadowColor          = UIColor.blackColor().CGColor
        self.layer.shadowRadius         = 3.0
        self.layer.shadowOffset         = CGSizeMake(0.0, 3.0)
        self.layer.shadowOpacity        = 0.9
        self.layer.shouldRasterize      = true

        selectedBackgroundView          = altSelectedBackgroundView
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

        self.groupLabel.layer.backgroundColor   = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8).CGColor
        self.groupLabel.layer.cornerRadius      = 15.0

        self.layer.rasterizationScale   = UIScreen.mainScreen().scale
        self.layer.shouldRasterize      = true
    }



    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.selected   = false
    }



    override func prepareForReuse() {
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

        self.backgroundColor            = UIColor(white: 0.85, alpha: 1.0)

        self.layer.masksToBounds        = true
        self.layer.borderColor          = UIColor.whiteColor().CGColor
        self.layer.borderWidth          = 1.0
        self.layer.shadowColor          = UIColor.blackColor().CGColor
        self.layer.shadowRadius         = 3.0
        self.layer.shadowOffset         = CGSizeMake(0.0, 3.0)
        self.layer.shadowOpacity        = 0.9
        self.layer.shouldRasterize      = true


        self.groupLabel.layer.backgroundColor   = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8).CGColor
        self.groupLabel.layer.cornerRadius      = 15.0
    }
}
