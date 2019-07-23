
import Foundation
import SitecoreSSC_SDK

/**
 Implement this protocol to receive items browsing events from the controller.
 */
@objc public protocol SCItemsBrowserDelegate: NSObjectProtocol {
    
    /**
     This event is called whenever some event in request processing occurs. For example,
     
     - HTTP request has been sent
     - HTTP response has neen received
     - Responce has been cached
     - etc.
     
     @param sender One of the items browser controllers below.
     * SCItemListBrowser
     * SCItemGridBrowser
     
     @param progressInfo At the moment there is no single class that holds the progress information. To be defined...
     */
    func itemsBrowser(_ itemsBrowser: Any, didReceiveLevelProgressNotification progressInfo: Any)
    
    /**
     This method is called when a given level has failed to load.
     
     @param sender One of the items browser controllers below.
     
     - SCItemListBrowser
     - SCItemGridBrowser
     
     @param error An error object received from the Mobile SDK.
     */
    func itemsBrowser(_ itemsBrowser: Any, levelLoadingFailedWithError error: NSError?)
    
    /**
     This method is called to determine whether the browser should navigate down for this item.
     You can use it either to restrict the user from not seeing some branches of the content tree or to define some custom parent-child item relationships.
     
     @param sender One of the items browser controllers below.
     
     - SCItemListBrowser
     - SCItemGridBrowser
     
     @param levelParentItem An item selected by the user.
     
     @return YES if the item is considered to have child items.
     */
    func itemsBrowser(_ itemsBrowser: Any, shouldLoadLevelForItem levelParentItem: ISitecoreItem) -> Bool
    
    /**
     This method notifies about successful level load for the item selected by the user.
     
     @param sender One of the items browser controllers below.
     
     - SCItemListBrowser
     - SCItemGridBrowser
     
     @param levelParentItem The root of a successfully loaded level of items.
     */
    func itemsBrowser(_ itemsBrowser: Any, didLoadLevelForItem levelParentItem: ISitecoreItem)
    
//    /**
//     This method should provide comparator to sort items list recived from server. Return nil if no sorting needed.
//     
//     @param sender One of the items browser controllers below.
//     
//     - SCItemListBrowser
//     - SCItemGridBrowser
//     
//     @return A standard Apple's NSComparator predicate.
//     
//     Return nil or do not implement this method if no sorting is required.
//     */
//    #warning ("TODO: @igk make optional!")
//    func sortResultComparatorForItemsBrowser(_ itemsBrowser: Any) -> Comparator
}
