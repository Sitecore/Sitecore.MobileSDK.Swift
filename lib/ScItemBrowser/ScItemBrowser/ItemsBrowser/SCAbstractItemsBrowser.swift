//
//  SCAbstractItemsBrowser.swift
//  ScItemBrowser
//
//  Created by IGK on 12/11/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

public class SCAbstractItemsBrowser: NSObject {
    
    private var _apiSession: SscSession? = nil
    private var _rootItem: ISitecoreItem? = nil
    private var _nextLevelRequestBuilder: SCItemsLevelRequestBuilder? = nil
    private var _delegate: SCItemsBrowserDelegate? = nil
    
    
    private var _itemsFileManager: SCItemsFileManager? = nil
    
    var loadedLevel: SCLevelResponse? = nil
    
    func reloadDataIgnoringCache(_ shouldIgnoreCache: Bool)
    {
        let fmCallbacks: SCItemsFileManagerCallbacks = self.newCallbacksForItemsFileManager()
        
        if (!(self.lazyItemsFileManager!.isRootLevelLoaded))
        {
            self.lazyItemsFileManager?.loadLevelForItem(self._rootItem!, callbacks: fmCallbacks, ignoringCache: shouldIgnoreCache)
        }
        else
        {
            self.lazyItemsFileManager?.reloadCurrentLevelNotifying(fmCallbacks, ignoringCache: shouldIgnoreCache)
        }
    }
    
    func didSelectItem(_ selectedItem: ISitecoreItem, at indexPath: IndexPath){
       let isLevelUpItem: Bool = type(of: selectedItem) == SCLevelUpItem.self
        let callbacks = self.newCallbacksForItemsFileManager()
        
        if (isLevelUpItem){
            self.itemsFileManager!.goToLevelUpNotifyingCallbacks(callbacks)
        }
        
    }
    
    func newCallbacksForItemsFileManager() -> SCItemsFileManagerCallbacks{
        
        let callbacks = SCItemsFileManagerCallbacks()
        do {
            callbacks.onLevelLoadedBlock = { levelResponse, levelError in
                if nil == levelResponse {
                    self.onLevelReloadFailedWithError(levelError!)
                } else {
                    self.onLevelReloaded(levelResponse!)
                }
            }
            
            callbacks.onLevelProgressBlock = { progressInfo in
                self.delegate!.itemsBrowser(self, didReceiveLevelProgressNotification: progressInfo!)
            }
            
        }
        
        return callbacks

    }
    
    func onLevelReloadFailedWithError(_ levelError: Error) {
        self.delegate!.itemsBrowser(self, levelLoadingFailedWithError: levelError)
    }
    
    func onLevelReloaded(_ levelResponse: SCLevelResponse) {
        assert(nil != levelResponse.levelParentItem, "Invalid parameter not satisfying: nil != levelResponse?.levelParentItem")
        
        // @adk : order matters
        self.loadedLevel = levelResponse
        self.reloadContentView()
        
        self.delegate!.itemsBrowser(self, didLoadLevelForItem: loadedLevel!.levelParentItem)
    }

    func reloadContentView() {
        self.doesNotRecognizeSelector(#function)
    }
    
    func disposeLazyItemsFileManager(){
        self._itemsFileManager = nil
    }
}

//LazyProperties
extension SCAbstractItemsBrowser  {

    var lazyItemsFileManager: SCItemsFileManager? {
        guard self._apiSession != nil, self._nextLevelRequestBuilder != nil else {
            return nil
        }
        
        guard self._itemsFileManager != nil else {
            self._itemsFileManager = SCItemsFileManager(apiSession: self._apiSession!, nextLevelRequestBuilder: self._nextLevelRequestBuilder!)
            return nil
        }
        
        return self._itemsFileManager!
    }
    
    var itemsFileManager: SCItemsFileManager? {
        return self._itemsFileManager
    }
    
}

extension SCAbstractItemsBrowser: SCItemsBrowserProtocol {
    
    func reloadData() {
        self.reloadDataIgnoringCache(false)
    }
    
    func forceRefreshData() {
        self.reloadDataIgnoringCache(true)
    }
    
    func navigateToRootItem() {
        self.disposeLazyItemsFileManager()
        let fmCallbacks: SCItemsFileManagerCallbacks = self.newCallbacksForItemsFileManager()
        
        self.lazyItemsFileManager!.loadLevelForItem(self.rootItem!, callbacks: fmCallbacks, ignoringCache: false)
    }
    
    
}

extension SCAbstractItemsBrowser: SCItemsBrowserInitialization {
    
    var apiSession: SscSession? {
        return self._apiSession
    }
    
    func setApiSession(_ apiSession: SscSession) {
        assert(nil == self._apiSession, "apiSession can be assigned only once")
        self._apiSession = apiSession
    }
    
    var rootItem: ISitecoreItem? {
        return self._rootItem
    }
    
    func setRootItem(_ rootItem: ISitecoreItem) {
        assert(nil == self._rootItem, "rootItem can be assigned only once")
        self._rootItem = rootItem
    }
    
    var nextLevelRequestBuilder: SCItemsLevelRequestBuilder? {
        return self._nextLevelRequestBuilder
    }
    
    func setNextLevelRequestBuilder(_ nextLevelRequestBuilder: SCItemsLevelRequestBuilder) {
        assert(nil == self._nextLevelRequestBuilder, "nextLevelRequestBuilder can be assigned only once")
        self._nextLevelRequestBuilder = nextLevelRequestBuilder
    }
    
    var delegate: SCItemsBrowserDelegate? {
        return self._delegate
    }
    
    func setDelegate(_ delegate: SCItemsBrowserDelegate) {
        assert(nil == self._delegate, "delegate can be assigned only once")
        self._delegate = delegate
    }
    
    
}


class SCLevelUpItem : ISitecoreItem {
    
    var source: IItemSource? = nil
    
    var displayName: String = ""
    
    var hasChildren: Bool = false
    
    var id: String = ""
    
    var path: String = ""
    
    var templateId: String = ""
    
    var fieldsCount: Int = 0
    
    var fields: [String : Any] = [:]
    
    
}
