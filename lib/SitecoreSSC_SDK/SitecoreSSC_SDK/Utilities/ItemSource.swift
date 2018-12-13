//
//  ItemSource.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/29/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

public protocol IItemSource {
    var database:       String  { get }
    var language:       String  { get }
    var versionNumber:  Int?    { get }
}

public class ItemSource: IItemSource {
    
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
        versionNumber:  Int?
    )
    {
        self.database = database
        self.language = language
        self.versionNumber = versionNumber
    }

    public let database: String
    public let language: String
    public let versionNumber: Int?
    
    
}
