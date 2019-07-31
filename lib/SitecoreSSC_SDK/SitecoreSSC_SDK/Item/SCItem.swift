
import Foundation

public class SCItem: NSObject, ISitecoreItem {
    
    public let sessionConfig: ISessionConfig?
    public let source: IItemSource?
    public let fields: [String : Any]
    
    init(fields: [String : Any], sessionConfig: ISessionConfig?, source: IItemSource?)
    {
        self.sessionConfig = sessionConfig
        self.fields = fields
        self.source = source
    }
    
    deinit
    {
        self.clearResources()
    }
    
    public var displayName: String
    {
        get
        {
            guard let displayName = self.fields[SCItemDefaults.DisplayNameFieldTitle] as? String else
            {
                return ""
            }
            
            return displayName
        }
    }
    
    public var isMediaImage: Bool
    {
        get
        {
            guard let mimeType: String = self.fields[SCItemDefaults.MimeTypeFieldTitle] as? String else
            {
                return false
            }
            
            return mimeType.hasPrefix("image/")
        }
    }
    
    public var hasChildren: Bool
    {
        get
        {
            guard let hasChildren = self.fields[SCItemDefaults.HasChildrenFieldTitle] as? String else
            {
                return false
            }
            return NSString(string: hasChildren).boolValue
        }
    }
    
    public var id: UUID
    {
        get
        {
            guard let itemIdValue: UUID = UUID(uuidString: self.fields[SCItemDefaults.ItemIDFieldTitle]! as! String) else
            {
                fatalError("itemId unknown format")
            }
            
            return itemIdValue
        }
    }
    
    public var path: String
    {
        get
        {
            return self.fields[SCItemDefaults.ItemPathFieldTitle]! as! String
        }
    }
    
    public var templateId: String
    {
        get
        {
            return self.fields[SCItemDefaults.TemplateIDFieldTitle]! as! String
        }
    }
    
    public var fieldsCount: Int
    {
        get
        {
            return self.fields.count
        }
    }

//MARK: -
//MARK: working with data

    private var handlers: DataDownloadingProcess?
    private var requestToken: RequestToken?
    
    public func cancelDataLoading()
    {
        guard let requestToken = self.requestToken else
        {
            return
        }

        requestToken.cancel()
        
        self.imageLoadCanceled()
    }
    
 
    public func getImage(handlers: DataDownloadingProcess)
    {
        self.handlers = handlers
        
        let itemHandlers = DataDownloadingProcess(completionHandler: imageLoaded,
                                                     errorHandler: imageLoadFailed,
                                                     cancelationHandler: imageLoadCanceled)
        
        guard let sessionConfig = self.sessionConfig else
        {
            self.imageLoadFailed(SSCError.badRequest("sessionConfig must not be nil"))
            return
        }
        
        self.requestToken = ScImageLoader.getImageWithRequest(self, sessionConfig: sessionConfig, completion: itemHandlers)
    }
    
    func imageLoaded(_ image: UIImage)
    {
        guard let handlers = self.handlers else
        {
            return
        }
        
        handlers.downloadCompletionHandler(image)
        self.clearResources()
    }
    
    func imageLoadFailed(_ error: Error)
    {
        guard let handlers = self.handlers else
        {
            return
        }
        
        handlers.downloadErrorHandler(error)
        self.clearResources()
    }
    
    func imageLoadCanceled()
    {
        guard let handlers = self.handlers else
        {
            return
        }
        
        handlers.downloadCancelationHandler()
        self.clearResources()
    }
    
    private func clearResources()
    {
        self.handlers = nil
        self.requestToken = nil
    }
    
    public func getField(_ key: String) -> String
    {
        guard let value = self.fields[key] as? String else
        {
            return ""
        }
        
        return value
    }
}



@objc public protocol ISitecoreItem: NSObjectProtocol
{
    //@IGK actual item source for getChildrenFor(item: ISitecoreItem) like requests
    var source:       IItemSource? { get }
    var sessionConfig: ISessionConfig? { get }
    
    var displayName:  String      { get }
    var hasChildren:  Bool        { get }
    var id:           UUID        { get }
    var path:         String      { get }
    var templateId:   String      { get }
    var fieldsCount:  Int         { get }
    
    var fields:       [String: Any] { get }
    
    var isMediaImage: Bool         { get }
    
    func getField(_ key: String) -> String
  
    //@IGK hack to simplify image loading bypassing session
    func getImage(handlers: DataDownloadingProcess)
    func cancelDataLoading()
}






