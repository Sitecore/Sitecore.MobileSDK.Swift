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

    init(delegate: SCMediaCellDelegate) {
        self.customSession = nil
        self.delegate = delegate
    }
    
    init(customSession: SscSession?, delegate: SCMediaCellDelegate) {
        self.customSession = customSession
        self.delegate = delegate
    }
    
    func setModel(item: ISitecoreItem){
        #warning("@igk cancel previous downloads")
        self.item = item
    }
    
    func reloadData(){
        guard let item = self.item else {
            self.delegate.mediaCellController(self, didFailLoadingImageForItem: self.item!, withError: NSError(domain: "SCMediaCellController", code: 0, userInfo: ["Error" : "item is nil"]))
            return
        }
        
        self.startLoading()
        
        if (self.customSession != nil)
        {
            self.customSession!.downloadImageForItem(item) { (image, error) in
                
                guard let image = image else
                {
                    self.delegate.mediaCellController(self, didFailLoadingImageForItem: self.item, withError: error!)
                    return
                }
                
                self.delegate.mediaCellController(self, didFinishLoadingImage: image, forItem: self.item!)
            }
        }
        else
        {
            ScImageLoader.getImageWithRequest(self.item!) { (image, error) in
                var scError: Error? = error
                
                if (image == nil) {
                    
                    if (scError == nil){
                        scError = NSError(domain: "SitecoreSSC", code: 0, userInfo: ["Info": "Can not download image"])
                    }
                    
                    let netError = SscError.networkError(scError)
                    
                    self.delegate.mediaCellController(self, didFailLoadingImageForItem: self.item, withError: netError)
                    
                } else {
                    self.delegate.mediaCellController(self, didFinishLoadingImage: image!, forItem: self.item!)
                }
            }
        }
    }
    
    func startLoading() {
        self.delegate.didStartLoadingImageInMediaCellController(sender: self)
    }
}
