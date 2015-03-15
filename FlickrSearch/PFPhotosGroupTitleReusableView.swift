//
//  PFPhotosGroupTitleReusableView.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 3/14/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//




import UIKit




class PFPhotosGroupTitleReusableView: UICollectionReusableView
{
    var titleLabel: UILabel




    required init(coder aDecoder: NSCoder)
    {
        self.titleLabel                     = UILabel()

        super.init(coder: aDecoder)
    }




    override init(frame: CGRect)
    {
        self.titleLabel                     = UILabel()
        
        super.init(frame: frame)

        self.titleLabel                     = UILabel(frame: self.bounds)
        self.titleLabel.autoresizingMask    = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        self.titleLabel.backgroundColor     = UIColor.clearColor()
        self.titleLabel.textAlignment       = NSTextAlignment.Center
        self.titleLabel.font                = UIFont.systemFontOfSize(15.0)
        self.titleLabel.textColor           = UIColor.whiteColor()
        self.titleLabel.shadowColor         = UIColor(white: 0.0, alpha: 0.3)
        self.titleLabel.shadowOffset        = CGSizeMake(0.0, 1.0)

        self.addSubview(self.titleLabel)
    }



    override func prepareForReuse()
    {
        super.prepareForReuse()

        titleLabel.text     = nil
    }
}
