//
//  SCItemsBrowserProtocol.swift
//  ScItemBrowser
//
//  Created by IGK on 12/4/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

/**
 This protocol describes data load methods that should be supported by each viewController.
 */
public protocol SCItemsBrowserProtocol {
    /**
     Reloads items using default settings of SCApiSession.
     */
    func reloadData()
    
    /**
     Reloads items by activating the SCReadItemRequestIngnoreCache flag.
     */
    func forceRefreshData()
    
    
    /**
     Loads child items of the root item using default settings of SCApiSession.
     */
    func navigateToRootItem()
}
