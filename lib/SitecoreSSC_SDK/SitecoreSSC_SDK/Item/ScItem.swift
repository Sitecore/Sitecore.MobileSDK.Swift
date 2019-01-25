//
//  ScItem.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/23/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

public class ScItem: NSObject, ISitecoreItem {
    
    #warning ("@igk make all fields readonly!")
    
    public var sessionConfig: ISessionConfig?
    public var source: IItemSource?
    
    public var displayName: String
    {
        get{
            return self.fields["DisplayName"]! as! String
        }
    }
    
    public var isMediaImage: Bool
    {
        get
        {
            guard let mimeType: String = self.fields["Mime Type"] as? String else
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
            return NSString(string: self.fields["HasChildren"]! as! String).boolValue
        }
    }
    
    public var id: String
    {
        get
        {
            return self.fields["ItemID"]! as! String
        }
    }
    
    public var path: String
    {
        get
        {
            return self.fields["ItemPath"]! as! String
        }
    }
    
    public var templateId: String
    {
        get
        {
            return self.fields["TemplateID"]! as! String
        }
    }
    
    public var fieldsCount: Int
    {
        get
        {
            return self.fields.count
        }
    }
    
    public let fields: [String : Any]
    
    init (fields: [String : Any], source: IItemSource?, sessionConfig: ISessionConfig?)
    {
        self.fields = fields
        self.source = source
        self.sessionConfig = sessionConfig
    }

    deinit
    {
        self.clearResources()
    }
//MARK: -
//MARK: working with data

    private var handlers: DataDownloadingProcessing?
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
    
 
    public func getImage(handlers: DataDownloadingProcessing)
    {
        self.handlers = handlers
        
        let itemHandlers = DataDownloadingProcessing(completionHandler: imageLoaded,
                                                     errorHandler: imageLoadFailed,
                                                     cancelationHandler: imageLoadCanceled)
        
        self.requestToken = ScImageLoader.getImageWithRequest(self, completion: itemHandlers)
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
}



@objc public protocol ISitecoreItem: NSObjectProtocol
{
    var source:       IItemSource? { get }
    var sessionConfig: ISessionConfig? { get }
    
    var displayName:  String      { get }
    var hasChildren:  Bool        { get }
    var id:           String      { get }
    var path:         String      { get }
    var templateId:   String      { get }
    var fieldsCount:  Int         { get }
    
    var fields:       [String: Any] { get }
    
    var isMediaImage: Bool         { get }
  
    func getImage(handlers: DataDownloadingProcessing)
    func cancelDataLoading()
}






