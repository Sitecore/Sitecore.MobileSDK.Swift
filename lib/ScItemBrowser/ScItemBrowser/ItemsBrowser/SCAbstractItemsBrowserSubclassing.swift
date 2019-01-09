//
//  SCAbstractItemsBrowserSubclassing.swift
//  ScItemBrowser
//
//  Created by IGK on 1/9/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

/**
 Override methods of this protocol when subclassing SCAbstractItemsBrowser.
 */
@objc protocol SCAbstractItemsBrowserSubclassing
{
    /**
     This method is triggered by the SCAbstractItemsBrowser each time contents of a given level are successfully loaded. Your implementation must call **reloadData** method of the content view you are using.
     
     Note : content view should be reloaded both on level down and level up events.
     */
    func reloadContentView()
    
    
    /**
     This method should be triggered by the delegate of your content view. Depending on the selectedItem the SCAbstractItemsBrowser will decide whether it chould go to the next level or to the upper level.
     This method is already implemented in the SCAbstractItemsBrowser. However, you are responsible for invoking it in your sub-class.
     
     @param selectedItem An item selected by the user in the content view. It can be a sub-class of
     
     - SCItem
     - SCLevelUpItem
     
     @param indexPath Index path of the selected item.
     
     */
    @objc optional func didSelectItem(_ selectedItem: Any, at indexPath: IndexPath)
}
