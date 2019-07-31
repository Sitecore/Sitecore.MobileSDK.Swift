
import Foundation
import SitecoreSSC_SDK

public class SCAbstractItemsBrowser: NSObject
{
    
    private var _apiSession: ISSCReadOnlySession? = nil
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
    
    func didSelectItem(_ selectedItem: ISitecoreItem, at indexPath: IndexPath)
    {
       let isLevelUpItem: Bool = type(of: selectedItem) == SCLevelUpItem.self
        let callbacks = self.newCallbacksForItemsFileManager()
        
        if (isLevelUpItem)
        {
            self.itemsFileManager!.goToLevelUpNotifyingCallbacks(callbacks)
        }
        else
        {
            let shouldGoDeeper: Bool = self.delegate.itemsBrowser(self, shouldLoadLevelForItem: selectedItem)
            if (shouldGoDeeper)
            {
                self.itemsFileManager?.loadLevelForItem(selectedItem, callbacks: callbacks, ignoringCache: false)
            }
        }
        
    }
    
    func newCallbacksForItemsFileManager() -> SCItemsFileManagerCallbacks
    {
        let onLevelLoadedBlock = { (levelResponse: SCLevelResponse?, levelError: SSCError?) in
                if nil == levelResponse
                {
                    self.onLevelReloadFailedWithError(levelError!)
                }
                else
                {
                    self.onLevelReloaded(levelResponse!)
                }
            }
            
        let onLevelProgressBlock = { progressInfo in
            self.delegate.itemsBrowser(self, didReceiveLevelProgressNotification: progressInfo)
        }
        
        let callbacks = SCItemsFileManagerCallbacks(onLevelLoadedBlock: onLevelLoadedBlock, onLevelProgressBlock: onLevelProgressBlock)
        
        return callbacks

    }
    
    func onLevelReloadFailedWithError(_ levelError: SSCError)
    {
        self.delegate.itemsBrowser(self, levelLoadingFailedWithError: levelError as NSError)
    }
    
    func onLevelReloaded(_ levelResponse: SCLevelResponse)
    {
        self.loadedLevel = levelResponse
        self.reloadContentView()
        
        self.delegate.itemsBrowser(self, didLoadLevelForItem: loadedLevel!.levelParentItem)
    }

    func reloadContentView()
    {
        self.doesNotRecognizeSelector(#function)
    }
    
    func disposeLazyItemsFileManager()
    {
        self._itemsFileManager = nil
    }
}

//LazyProperties
extension SCAbstractItemsBrowser
{

    var lazyItemsFileManager: SCItemsFileManager?
    {
        guard self._apiSession != nil, self._nextLevelRequestBuilder != nil else
        {
            return nil
        }
        
        if (self._itemsFileManager == nil)
        {
            self._itemsFileManager = SCItemsFileManager(apiSession: self._apiSession!, nextLevelRequestBuilder: self._nextLevelRequestBuilder!)
        }
        
        return self._itemsFileManager!
    }
    
    var itemsFileManager: SCItemsFileManager?
    {
        return self._itemsFileManager
    }
    
}

extension SCAbstractItemsBrowser: SCItemsBrowserProtocol
{
    
    public func reloadData()
    {
        self.reloadDataIgnoringCache(false)
    }
    
    public func forceRefreshData()
    {
        self.reloadDataIgnoringCache(true)
    }
    
    public func navigateToRootItem()
    {
        self.disposeLazyItemsFileManager()
        
        let fmCallbacks: SCItemsFileManagerCallbacks = self.newCallbacksForItemsFileManager()
        
        self.lazyItemsFileManager!.loadLevelForItem(self.rootItem!, callbacks: fmCallbacks, ignoringCache: false)
    }
    
}

extension SCAbstractItemsBrowser: SCItemsBrowserInitialization
{
    
    public var apiSession: ISSCReadOnlySession?
    {
        return self._apiSession
    }
    
    public func setApiSession(_ apiSession: ISSCReadOnlySession)
    {
        assert(nil == self._apiSession, "apiSession can be assigned only once")
        self._apiSession = apiSession
    }
    
    public var rootItem: ISitecoreItem?
    {
        return self._rootItem
    }
    
    public func setRootItem(_ rootItem: ISitecoreItem)
    {
        assert(nil == self._rootItem, "rootItem can be assigned only once")
        self._rootItem = rootItem
    }
    
    public var nextLevelRequestBuilder: SCItemsLevelRequestBuilder?
    {
        return self._nextLevelRequestBuilder
    }
    
    public func setNextLevelRequestBuilder(_ nextLevelRequestBuilder: SCItemsLevelRequestBuilder)
    {
        assert(nil == self._nextLevelRequestBuilder, "nextLevelRequestBuilder can be assigned only once")
        self._nextLevelRequestBuilder = nextLevelRequestBuilder
    }
    
    public var delegate: SCItemsBrowserDelegate
    {
        return self._delegate
    }
    
    public func setDelegate(_ delegate: SCItemsBrowserDelegate)
    {
        assert(nil == self._delegate, "delegate can be assigned only once")
        self._delegate = delegate
    }
    
    
}


class SCLevelUpItem : NSObject, ISitecoreItem
{
    func getField(_ key: String) -> String
    {
        return fields[key] as? String ?? ""
    }
    
    func cancelDataLoading()
    {
        doesNotRecognizeSelector(#function)
    }
    
    func getImage(handlers: DataDownloadingProcess)
    {
        doesNotRecognizeSelector(#function)
    }
    
    var sessionConfig: ISessionConfig? = nil
    
    var isMediaImage: Bool = false
    
    var source: IItemSource? = nil
    
    var displayName: String = "UP"
    
    var hasChildren: Bool = false
    
    #warning("@igk refactor this, optional type is not an option")
    var id: UUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")! //fake uuid    
    
    var path: String = ""
    
    var templateId: String = ""
    
    var fieldsCount: Int = 0
    
    var fields: [String : Any] = [:]
    
    
}
