//
//  SCMediaCellController.swift
//  ScItemBrowser
//
//  Created by IGK on 12/20/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

class SCMediaCellController {
    
    private var customSession: SscSession?
    private(set) var item: ISitecoreItem?
    
    public var delegate: SCMediaCellDelegate

    init(delegate: SCMediaCellDelegate)
    {
        self.customSession = nil
        self.delegate = delegate
    }
    
    init(customSession: SscSession?, delegate: SCMediaCellDelegate)
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
        self.delegate.didStartLoadingImageInMediaCellController(sender: self)
    }
    
    
    func reloadData()
    {
        guard let item = self.item else
        {
            self.imageLoadFailed(NSError(domain: "SCMediaCellController", code: 0, userInfo: ["Error" : "item is nil"]))
            return
        }
        
        self.startLoading()
        
        let handlers = DataDownloadingProcessing(completionHandler: imageLoaded,
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
        self.delegate.mediaCellController(self, didFinishLoadingImage: image, forItem: self.item!)
    }
    
    func imageLoadFailed(_ error: Error)
    {
        self.delegate.mediaCellController(self, didFailLoadingImageForItem: self.item, withError: error)
    }
    
    func imageLoadCanceled()
    {
        print("image loading canceled")
    }
    
}
