//
//  SIBListModeCellFactory.swift
//  ScItemBrowser
//
//  Created by IGK on 12/5/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

/**
 You must implement this protocol in order to construct cells and provide their reuse identifiers for the SCItemListBrowser controller. Typically, the cells should be inherited from the SCItemListCell class.
 
 You should not invoke dequeueReusableCellWithIdentifier: explicitly. SCItemListBrowser is responsible for doing so.
 */
public protocol SIBListModeCellFactory {
    
    /**
     Constructs a new cell for the level up item.
     
     @param sender SCItemListBrowser controller instance.
     
     @return A new cell.
     */
    func createLevelUpCellForListModeOfItemsBrowser(_ sender: SCItemListBrowser) -> UITableViewCell
    
    /**
     Constructs a new cell for the item cell.
     
     @param sender SCItemListBrowser controller instance.
     @param item An item to be rendered in the given cell.
     
     @return A new cell.
     */
    func itemsBrowser(_ sender: SCItemListBrowser, createListModeCellFor item: ISitecoreItem) -> (UITableViewCell & SCItemCell)

    /**
     Provides the reuse identifier for the level up item.
     
     @param sender SCItemListBrowser controller instance.
     */
    func reuseIdentifierForLevelUpCellOfItemsBrowser(_ sender: SCItemListBrowser) -> String
    
    /**
     Provides the reuse identifier for the item cell.
     
     @param sender SCItemListBrowser controller instance.
     @param item An item to be rendered in the given cell.
     */
    func itemsBrowser(_ sender: SCItemListBrowser, itemCellReuseIdentifierFor item: ISitecoreItem) -> String

}
