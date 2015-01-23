//
//  PFWeak.swift
//  FlickrSearch
//
//  Created by James Hillhouse IV on 1/22/15.
//  Copyright (c) 2015 PortableFrontier. All rights reserved.
//
//  Originally created by Drew Crawford on 1/16/15
//

import UIKit
import Foundation

public class Weak<T: AnyObject>
{
    public weak var value: T?
    public init (value: T)
    {
        self.value = value
    }
}
