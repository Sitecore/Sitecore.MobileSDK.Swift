//
//  ItemSource.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/29/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

@objc public protocol IItemSource: NSObjectProtocol {
    var database:       String  { get }
    var language:       String  { get }
    var versionNumber:  NSNumber?    { get }
}

public class ItemSource: NSObject, IItemSource {
    
    public init(
        database:       String,
        language:       String
        )
    {
        self.database = database
        self.language = language
        self.versionNumber = nil
    }
    
    public init(
        database:       String,
        language:       String,
        versionNumber:  NSNumber?
    )
    {
        self.database = database
        self.language = language
        self.versionNumber = versionNumber
    }

    public let database: String
    public let language: String
    public let versionNumber: NSNumber?
    
    
}
