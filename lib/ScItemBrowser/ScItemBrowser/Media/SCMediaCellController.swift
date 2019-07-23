
import Foundation
import SitecoreSSC_SDK

class SCMediaCellController {
    
    private var customSession: SSCSession?
    private(set) var item: ISitecoreItem?
    
    public weak var delegate: SCMediaCellDelegate?

    init()
    {
        self.customSession = nil
    }
    
    init(customSession: SSCSession?, delegate: SCMediaCellDelegate)
    {
        self.customSession = customSession
        self.delegate = delegate
    }
    
    func setModel(item: ISitecoreItem)
    {
        self.cancelImageLoading()
        self.item = item
    }
    
    func cancelImageLoading()
    {
        guard let item = self.item else { return }
        
        item.cancelDataLoading()
    }
    
    func startLoading()
    {
        guard let delegate = self.delegate else
        {
            return
        }
        
        delegate.didStartLoadingImageInMediaCellController(sender: self)
    }
    
    
    func reloadData()
    {
        guard let item = self.item else
        {
            self.imageLoadFailed(NSError(domain: "SCMediaCellController", code: 0, userInfo: ["Error" : "item is nil"]))
            return
        }
        
        self.startLoading()
        
        let handlers = DataDownloadingProcess(completionHandler: imageLoaded,
                                                   errorHandler: imageLoadFailed,
                                             cancelationHandler: imageLoadCanceled)
        
        if (self.customSession != nil)
        {
            self.customSession!.downloadImageForItem(item, completion: handlers)
        }
        else
        {
            item.getImage(handlers: handlers)
        }
    }
    
    func imageLoaded(_ image: UIImage)
    {
        guard let delegate = self.delegate else
        {
            return
        }
        
        delegate.mediaCellController(self, didFinishLoadingImage: image, forItem: self.item!)
    }
    
    func imageLoadFailed(_ error: Error)
    {
        guard let delegate = self.delegate else
        {
            return
        }
        
        delegate.mediaCellController(self, didFailLoadingImageForItem: self.item, withError: error)
    }
    
    func imageLoadCanceled()
    {
        guard let delegate = self.delegate else
        {
            return
        }
        
        delegate.mediaCellController(self, didFailLoadingImageForItem: self.item, withError: NSError(domain: "SCMediaCellController", code: 0, userInfo: ["Info" : "image loading canceled"]))
        print("image loading canceled")
    }
    
}
