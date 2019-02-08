//
//  ItemSource.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/29/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

@objc public protocol IItemSource
{
    var database:       String?  { get }
    var language:       String?  { get }
    var versionNumber:  NSNumber?    { get }
}

public class ItemSource: NSObject, IItemSource
{
    public let database: String?
    public let language: String?
    public let versionNumber: NSNumber?
    
    public init(
        database:       String? = nil,
        language:       String? = nil,
        versionNumber:  NSNumber? = nil
    )
    {
        self.database = database
        self.language = language
        self.versionNumber = versionNumber
    }

    
    
    
}
