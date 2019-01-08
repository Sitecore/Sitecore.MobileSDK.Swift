//
//  SscRequests.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/22/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation


@objc public protocol IOdataRequest: IBaseGetItemsRequest {
    var odataQuery: String { get }
}

@objc public protocol IGetByIdRequest: IBaseGetItemsRequest {
    var itemId: UUID { get }
}

@objc public protocol IGetByPathRequest: IBaseGetItemsRequest {
    var itemPath: String { get }
}

@objc public protocol IGetChildrenRequest: IBaseGetPaggedItemsRequest {
    var parentId: UUID { get }
}

@objc public protocol ISitecoreSearchRequest: IBaseGetPaggedItemsRequest {
    
}

@objc public protocol IStoredSitecoreSearchRequest: IBaseGetPaggedItemsRequest {
    
}

@objc public protocol IBaseGetPaggedItemsRequest: IBaseGetItemsRequest {
    var pagingParameters: IPagingParameters? { get }
}

@objc public protocol IBaseGetItemsRequest: IBaseRequest {
    
    var itemSource: IItemSource { get }
    var queryParameters: IQueryParameters? { get }
    var includeStandardTemplateFields: Bool { get }
    
    var ignoreCache: Bool { get }
    
}

@objc public protocol IBasePostRequest: IBaseRequest {
    
    func buildRequestBody() -> Data
    
}

@objc public protocol IBaseRequest: IScRequest {

    #warning ("@igk separate request builder required!")
    func buildHTTPRequest() throws -> URLRequest
    
}

@objc public protocol IGetImageRequest: IScRequest {
    
    var mediaItem: ISitecoreItem { get }
    
}

@objc public protocol IScRequest {
    
    var sessionConfig: ISessionConfig? { get }
    func buildUrl() -> String //TODO: @igk make it internal!!!!
    
}

@objc public protocol IQueryParameters {
    var fields: [String] { get }
}

@objc public protocol IPagingParameters {
    
    var itemsPerPageCount: Int { get }
    var pageNumber: Int { get }
    
}

