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

//MARK: -
//MARK: working with data

    private var cancelHandler: DownloadCancelationHandler?
    private var requestToken: RequestToken?
    
    public func cancelDataLoading()
    {
        guard let requestToken = self.requestToken else
        {
            return
        }

        requestToken.cancel()
        
        guard let cancel = self.cancelHandler else
        {
            return
        }
        
        cancel()
    }
 
    public func getImage(handlers: DataDownloadingProcessing)
    {
        self.cancelHandler = handlers.downloadCancelationHandler
        self.requestToken = ScImageLoader.getImageWithRequest(self, completion: handlers)
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






