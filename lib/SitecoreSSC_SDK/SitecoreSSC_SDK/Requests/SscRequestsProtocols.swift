//
//  SscRequests.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/22/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation



public protocol IGetByIdRequest: IBaseGetItemsRequest {
    var itemId: UUID { get }
}

public protocol IGetByPathRequest: IBaseGetItemsRequest {
    var itemPath: String { get }
}

public protocol IGetChildrenRequest: IBaseGetPaggedItemsRequest {
    var parentId: UUID { get }
}

public protocol ISitecoreSearchRequest: IBaseGetPaggedItemsRequest {
    
}

public protocol IStoredSitecoreSearchRequest: IBaseGetPaggedItemsRequest {
    
}

public protocol IBaseGetPaggedItemsRequest: IBaseGetItemsRequest {
    var pagingParameters: IPagingParameters? { get }
}

public protocol IBaseGetItemsRequest: IBaseRequest {
    
    var itemSource: IItemSource { get }
    var queryParameters: IQueryParameters? { get }
    var includeStandardTemplateFields: Bool { get }
    
}

public protocol IBasePostRequest: IBaseRequest {
    
    func buildRequestBody() -> Data
    
}

public protocol IBaseRequest {
    
    var sessionConfig: ISessionConfig? { get }
    func buildHTTPRequest() throws -> URLRequest
    func buildUrl() -> String //TODO: @igk make it internal!!!!
}


public protocol IQueryParameters {
    var fields: [String] { get }
}

public protocol IPagingParameters {
    
    var itemsPerPageCount: Int { get }
    var pageNumber: Int { get }
    
}

