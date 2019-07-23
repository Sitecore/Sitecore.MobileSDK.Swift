
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
