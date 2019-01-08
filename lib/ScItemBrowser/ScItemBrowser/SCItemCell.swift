//
//  SCItemCell.swift
//  ScItemBrowser
//
//  Created by IGK on 12/4/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

/**
 SCItemCell protocol represents object capable of rendering an item.
 */
@objc public protocol SCItemCell {
    
    /**
     Override this method to get information required for rendering out of the item. Please avoid storing the item itself if possible.
     
     @param item A sitecore item to render
     */
    
    func setModel(item: ISitecoreItem)
    
    /**
     Override this method to get the missing data from the instance and render your cell UI using it.
     */
    func reloadData()
    
}
