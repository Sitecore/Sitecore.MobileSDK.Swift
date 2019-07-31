
import Foundation
import SitecoreSSC_SDK

/**
 Basic initialization methods for any items browser controller.
 */
public protocol SCItemsBrowserInitialization {
    /**
     @return The session to communicate with the Sitecore instance.
     */
    var apiSession: ISSCReadOnlySession? { get }
    
    /**
     @param apiSession The session to communicate with the Sitecore instance.
     */
    func setApiSession(_ apiSession: ISSCReadOnlySession)
    
    /**
     @return An item to start browsing with.
     */
    var rootItem: ISitecoreItem? { get }
    
    /**
     @param rootItem An item to start browsing with.
     */
    func setRootItem(_ rootItem: ISitecoreItem)
    
    /**
     @return A factory to build level queries. It can be used to filter items.
     */
    var  nextLevelRequestBuilder: SCItemsLevelRequestBuilder? { get }
    
    /**
     @param nextLevelRequestBuilder A factory to build level queries. It can be used to filter items.
     */
    func setNextLevelRequestBuilder(_ nextLevelRequestBuilder: SCItemsLevelRequestBuilder)
    
    /**
     @return A delegate that gets notifications about levels loading.
     */
    var delegate: SCItemsBrowserDelegate { get }
    
    /**
     @param delegate A delegate that gets notifications about levels loading.
     */
    func setDelegate(_ delegate: SCItemsBrowserDelegate)
}
