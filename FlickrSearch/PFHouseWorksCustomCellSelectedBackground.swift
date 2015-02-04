//
//  PFHouseWorksCustomCellSelectedBackground.swift
//  PFHouseWorks
//
//  Created by James Hillhouse IV on 10/23/14.
//  Copyright (c) 2014 PortableFrontier. All rights reserved.
//




import UIKit




class PFHouseWorksCustomCellSelectedBackground: UIView
{

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        //println("cell selected background init coder.")
        fatalError("cell selected background init(coder:) has not been implemented")
    }



    override init(frame: CGRect)
    {
        //println("cell selected selected background init frame.")
        super.init(frame: frame)
    }



    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        //println("cell selected background drawing code")

        // draw a rounded rect bezier path filled with light grey
        var aRef: CGContextRef          = UIGraphicsGetCurrentContext()
        CGContextSaveGState(aRef)

        var bezierPath: UIBezierPath    = UIBezierPath.init(roundedRect: rect, cornerRadius: 3.0)
        bezierPath.lineWidth            = 5.0
        UIColor.blackColor().setStroke()

        var fillColor: UIColor          = UIColor(red: 0.0, green: 0.0, blue: 0.8, alpha: 1.0)
        fillColor.setFill()

        bezierPath.stroke()
        bezierPath.fill()
        
        CGContextRestoreGState(aRef)
    }
}
