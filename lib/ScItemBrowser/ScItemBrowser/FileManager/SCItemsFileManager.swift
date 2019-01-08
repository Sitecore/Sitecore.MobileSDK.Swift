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
typealias UpdateHistoryActionFromRequest = (IBaseGetItemsRequest?) -> UpdateHistoryActionBlock

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
        
        callbacks.onLevelProgressBlock!(self)
        
        let request: IBaseGetItemsRequest? = buildLevelRequest(for: item, ignoringCache: shouldIgnoreCache)
        
        let pushLevelAction = actionFromRequest(request)
        
        levelLoader(from: request!) { (response, error) in
            
            guard let urlResponse = response else {
                callbacks.onLevelLoadedBlock!(nil, error)
                return
            }
            
            pushLevelAction()

            let levelResponse = self.levelResponseWithLevelUpItemWith(response: urlResponse, levelParentItem: item)
            
            callbacks.onLevelLoadedBlock!(levelResponse, error)
            
        }
    }
    
    func levelResponseWithLevelUpItemWith(response: IItemsResponse, levelParentItem: ISitecoreItem) -> SCLevelResponse
    {
        var  loadedItems: [ISitecoreItem]
        
        if (self.levelsHistory.isLevelUpAvailable)
        {
            let fakeLevelUp: ISitecoreItem = SCLevelUpItem()
            loadedItems = [ fakeLevelUp ]
            loadedItems += response.items
        } else {
            loadedItems = response.items
        }
        
        return SCLevelResponse(levelParentItem: levelParentItem, levelContentItems: loadedItems)
        
    }
    
    func buildLevelRequest(for item: ISitecoreItem, ignoringCache shouldIgnoreCache: Bool) -> IBaseGetItemsRequest?
    {
        let request: IBaseGetItemsRequest = nextLevelRequestBuilder.itemsBrowser(self, levelDownRequestFor: item, ignoreCache: shouldIgnoreCache)
        
        if shouldIgnoreCache {
            #warning ("@igk implement http caching control in sdk!")
           // request?.flags |= SCReadItemRequestIngnoreCache
        }
        
        return request
    }
    
    func levelLoader(from request: IBaseGetItemsRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        
        #warning ("@igk not implemented")
        #warning ("@igk replace GetChildrenRequest with factory")
        
        apiSession.sendGetItemsRequest(request, completion: completion)
        
    
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
        
        if (self.levelsHistory.isLevelUpAvailable)
        {
            let request: IBaseGetItemsRequest = self.levelsHistory.levelUpRequest!
            let levelUpParentItem: ISitecoreItem = self.levelsHistory.levelUpParentItem!
            
            levelLoader(from: request) { (response, error) in
 
                self.levelsHistory.popRequest()

                let levelResponse = self.levelResponseWithLevelUpItemWith(response: response!, levelParentItem: levelUpParentItem)
                
                callbacks.onLevelLoadedBlock!(levelResponse, error)
            }
        }
    }

}
