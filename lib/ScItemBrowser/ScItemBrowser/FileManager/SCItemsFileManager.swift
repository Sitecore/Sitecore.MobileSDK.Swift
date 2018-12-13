//
//  SCItemsFileManager.swift
//  ScItemBrowser
//
//  Created by IGK on 12/5/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

typealias UpdateHistoryActionBlock = () -> Void
typealias UpdateHistoryActionFromRequest = (IGetChildrenRequest?) -> UpdateHistoryActionBlock

protocol ISCItemsFileManager {
    var levelsHistory: SCLevelsHistory { get }
}

class SCItemsFileManager : ISCItemsFileManager
{
    var levelsHistory: SCLevelsHistory
    
    private let apiSession: SscSession
    private let nextLevelRequestBuilder: SCItemsLevelRequestBuilder
    
    public init(apiSession: SscSession, nextLevelRequestBuilder: SCItemsLevelRequestBuilder) {
        self.apiSession = apiSession
        self.nextLevelRequestBuilder = nextLevelRequestBuilder
        self.levelsHistory = SCLevelsHistory()
    }
    
    var isRootLevelLoaded: Bool {
        return self.levelsHistory.isRootLevelLoaded
    }
    
    func loadLevelForItem(_ item: ISitecoreItem, callbacks: SCItemsFileManagerCallbacks, ignoringCache shouldIgnoreCache: Bool)
    {
        let pushLevelActionFromRequest: UpdateHistoryActionFromRequest = { request in
            let pushLevelAction = {
                self.levelsHistory.pushRequest(request!, for: item)
                }
            return pushLevelAction
        }
        
        self.loadLevelForItem(item, callbacks: callbacks, ignoringCache: shouldIgnoreCache, pushLevelActionBuilder: pushLevelActionFromRequest)
    }
    
    
    func loadLevelForItem(_ item: ISitecoreItem,
                          callbacks: SCItemsFileManagerCallbacks,
                          ignoringCache shouldIgnoreCache:Bool,
                          pushLevelActionBuilder actionFromRequest: UpdateHistoryActionFromRequest)
    {
        #warning("@igk add checks for all nil objects")
        
        let request: IGetChildrenRequest? = buildLevelRequest(for: item, ignoringCache: shouldIgnoreCache)
        levelLoader(from: request!) { (response, error) in
            
            let levelResponse = SCLevelResponse(levelParentItem: item, levelContentItems: (response?.items)!)
            
            callbacks.onLevelLoadedBlock!(levelResponse, error)
            
        }
    }
    
    func buildLevelRequest(for item: ISitecoreItem, ignoringCache shouldIgnoreCache: Bool) -> IGetChildrenRequest?
    {
        let request: IGetChildrenRequest = nextLevelRequestBuilder.itemsBrowser(self, levelDownRequestFor: item)
        
        if shouldIgnoreCache {
            #warning ("@igk implement http caching control in sdk!")
           // request?.flags |= SCReadItemRequestIngnoreCache
        }
        
        return request
    }
    
    func levelLoader(from request: IGetChildrenRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        
        #warning ("@igk not implemented")
        #warning ("@igk replace GetChildrenRequest with factory")
        
        apiSession.sendGetItemsRequest(request: request as! GetChildrenRequest, completion: completion)
        
    
    }
    
    func reloadCurrentLevelNotifying(_ callbacks: SCItemsFileManagerCallbacks, ignoringCache shouldIgnoreCache: Bool) {
        
        let item = levelsHistory.lastItem

        
        let idleAction: UpdateHistoryActionFromRequest = { request in
            let pushLevelAction = {
                //idle
            }
            return pushLevelAction
        }
        
        self.loadLevelForItem(item,
                              callbacks: callbacks,
                              ignoringCache: shouldIgnoreCache,
                              pushLevelActionBuilder: idleAction)
    }
    
    func goToLevelUpNotifyingCallbacks(_ callbacks: SCItemsFileManagerCallbacks) {
        
        let request: IGetChildrenRequest = self.levelsHistory.levelUpRequest!
        let levelUpParentItem: ISitecoreItem = self.levelsHistory.levelUpParentItem!
        
        let levelsHistory: SCLevelsHistory = self.levelsHistory
        
        levelLoader(from: request) { (response, error) in
            
            let levelResponse = SCLevelResponse(levelParentItem: levelUpParentItem, levelContentItems: (response?.items)!)
            
            callbacks.onLevelLoadedBlock!(levelResponse, error)
            
        }
    }

}
