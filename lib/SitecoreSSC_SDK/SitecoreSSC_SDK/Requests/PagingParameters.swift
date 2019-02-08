//
//  PagingParameters.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 2/8/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

public class PagingParameters: NSObject, IPagingParameters
{
    public var itemsPerPageCount: Int
    public var pageNumber: Int
    
    public init(itemsPerPage: Int, pageNumber: Int)
    {
        self.itemsPerPageCount = itemsPerPage
        self.pageNumber = pageNumber
    }
}

@objc public protocol IPagingParameters: class
{
    var itemsPerPageCount: Int { get }
    var pageNumber: Int { get }
}
