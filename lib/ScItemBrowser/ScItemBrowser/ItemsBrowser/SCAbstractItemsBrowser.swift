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
    @IBOutlet public weak var  _nextLevelRequestBuilder: SCItemsLevelRequestBuilder!
    @IBOutlet public weak var  _delegate: SCItemsBrowserDelegate!
    
    
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
        } else {
            let shouldGoDeeper: Bool = self.delegate.itemsBrowser(self, shouldLoadLevelForItem: selectedItem)
            if (shouldGoDeeper){
                self.itemsFileManager?.loadLevelForItem(selectedItem, callbacks: callbacks, ignoringCache: false)
            }
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
                self.delegate.itemsBrowser(self, didReceiveLevelProgressNotification: progressInfo!)
            }
            
        }
        
        return callbacks

    }
    
    func onLevelReloadFailedWithError(_ levelError: SscError) {
        self.delegate.itemsBrowser(self, levelLoadingFailedWithError: levelError as NSError)
    }
    
    func onLevelReloaded(_ levelResponse: SCLevelResponse) {        
        // @adk : order matters
        
            self.loadedLevel = levelResponse
        
        DispatchQueue.main.async {
            self.reloadContentView()
        }
        
        self.delegate.itemsBrowser(self, didLoadLevelForItem: loadedLevel!.levelParentItem)
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
        
        if (self._itemsFileManager == nil) {
            self._itemsFileManager = SCItemsFileManager(apiSession: self._apiSession!, nextLevelRequestBuilder: self._nextLevelRequestBuilder!)
        }
        
        return self._itemsFileManager!
    }
    
    var itemsFileManager: SCItemsFileManager? {
        return self._itemsFileManager
    }
    
}

extension SCAbstractItemsBrowser: SCItemsBrowserProtocol {
    
    public func reloadData() {
        self.reloadDataIgnoringCache(false)
    }
    
    public func forceRefreshData() {
        self.reloadDataIgnoringCache(true)
    }
    
    public func navigateToRootItem() {
        
        self.disposeLazyItemsFileManager()
        
        let fmCallbacks: SCItemsFileManagerCallbacks = self.newCallbacksForItemsFileManager()
        
        self.lazyItemsFileManager!.loadLevelForItem(self.rootItem!, callbacks: fmCallbacks, ignoringCache: false)
    }
    
    
}

extension SCAbstractItemsBrowser: SCItemsBrowserInitialization {
    
    public var apiSession: SscSession? {
        return self._apiSession
    }
    
    public func setApiSession(_ apiSession: SscSession) {
        assert(nil == self._apiSession, "apiSession can be assigned only once")
        self._apiSession = apiSession
    }
    
    public var rootItem: ISitecoreItem? {
        return self._rootItem
    }
    
    public func setRootItem(_ rootItem: ISitecoreItem) {
        assert(nil == self._rootItem, "rootItem can be assigned only once")
        self._rootItem = rootItem
    }
    
    public var nextLevelRequestBuilder: SCItemsLevelRequestBuilder? {
        return self._nextLevelRequestBuilder
    }
    
    public func setNextLevelRequestBuilder(_ nextLevelRequestBuilder: SCItemsLevelRequestBuilder) {
        assert(nil == self._nextLevelRequestBuilder, "nextLevelRequestBuilder can be assigned only once")
        self._nextLevelRequestBuilder = nextLevelRequestBuilder
    }
    
    public var delegate: SCItemsBrowserDelegate {
        return self._delegate
    }
    
    public func setDelegate(_ delegate: SCItemsBrowserDelegate) {
        assert(nil == self._delegate, "delegate can be assigned only once")
        self._delegate = delegate
    }
    
    
}


class SCLevelUpItem : NSObject, ISitecoreItem {
    
    var isMediaImage: Bool = false
    
    var source: IItemSource? = nil
    
    var displayName: String = ""
    
    var hasChildren: Bool = false
    
    var id: String = ""
    
    var path: String = ""
    
    var templateId: String = ""
    
    var fieldsCount: Int = 0
    
    var fields: [String : Any] = [:]
    
    
}
