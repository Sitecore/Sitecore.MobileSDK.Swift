//
//  SCItemsLevelRequestBuilder.swift
//  ScItemBrowser
//
//  Created by IGK on 12/4/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

/**
 This protocol is used to define parent-child relationships for the items being browsed.
 
 The most often case is filtering by template and plain parent-child concepts usage.
 They are represented by the classes below
 
 - SIBAllChildrenRequestBuilder
 - SIBWhiteListTemplateRequestBuilder
 - SIBBlackListTemplateRequestBuilder
 
 */
@objc public protocol SCItemsLevelRequestBuilder: NSObjectProtocol {
    /**
     Override this method to set the parent-child or filtering relationships for the items being browsed.
     
     @param sender One of the items browser controllers below.
     
     - SCItemListBrowser
     - SCItemGridBrowser
     
     @param item The children list should be defined for it by this class.
     
     @return A request that defines the scope of child items.
     */
    func itemsBrowser(_ itemsBrowser: Any, levelDownRequestFor item: ISitecoreItem, ignoreCache: Bool) -> IBaseGetItemsRequest
}
