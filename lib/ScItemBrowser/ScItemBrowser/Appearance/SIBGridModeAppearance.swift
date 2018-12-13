//
//  SIBGridModeAppearance.swift
//  ScItemBrowser
//
//  Created by IGK on 12/5/18.
//  Copyright © 2018 Igor. All rights reserved.
//


import Foundation
import SitecoreSSC_SDK

/**
 Since SCItemGridBrowser overrides the UICollectionViewDelegate and UICollectionViewDataSource protocols, there should be some way to configure cells appearance.
 
 Override methods of this protocol to forward your values to the UICollectionView and customize its appearance.
 */
#warning ("@igk all this should be optional")
protocol SIBGridModeAppearance {
    
    /**
     Tells the delegate that the item at the specified index path was highlighted. Overloading this method you may do some changes to the cell so that the user gets visual feedback while tapping on it.
     
     Note : we recommend overloading the [UICollectionViewCell setHighlighted:] method to add visual effects if you are aiming for the UITableView style highlighting.
     
     @param sender SCItemGridBrowser controller instance.
     @param cell A UICollectionViewCell the user interacts with
     @param item An item displayed within the given cell
     @param indexPath NSIndexPath value for the given cell
     
     */
    func itemsBrowser(_ sender: SCItemGridBrowser, didHighlight cell: UICollectionViewCell, for item:ISitecoreItem, at indexPath: NSIndexPath)

    /**
     Tells the delegate that the item at the specified index path was unhighlighted. Overloading this method you may revert the cell's appearance to the initial state so that the user gets visual feedback while finishing tapping on it.
     
     Note : we recommend overloading the [UICollectionViewCell setHighlighted:] method to add visual effects if you are aiming for the UITableView style highlighting.
     
     @param sender SCItemGridBrowser controller instance.
     @param cell A UICollectionViewCell the user interacts with
     @param item An item displayed within the given cell
     @param indexPath NSIndexPath value for the given cell
     
     */
    func itemsBrowser(_ sender: SCItemGridBrowser, didUnhighlight cell: UICollectionViewCell, for item:ISitecoreItem, at indexPath: NSIndexPath)
    
    /**
     Asks for the custom transition layout to use when moving between the specified layouts.
     See [UICollectionView collectionView:transitionLayoutForOldLayout:newLayout:] documentation for details.
     
     @param sender SCItemGridBrowser controller instance.
     @param fromLayout The current layout of the collection view. This is the starting point for the transition.
     @param toLayout The new layout for the collection view.
     
     @return The collection view transition layout object to use to perform the transition.
     */
    func itemsBrowser(_ sender: SCItemGridBrowser, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout
}
