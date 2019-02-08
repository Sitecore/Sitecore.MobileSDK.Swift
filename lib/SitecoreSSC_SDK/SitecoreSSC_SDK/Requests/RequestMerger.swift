//
//  RequestMerger.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 12/20/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

class RequestMerger {
    
    let sessionConfig: ISessionConfig
    
    public init(sessionConfig: ISessionConfig){
        self.sessionConfig = sessionConfig
    }
    
    public func mergeGetRequest(_ request: IBaseGetItemsRequest) -> IBaseGetItemsRequest
    {
        var result: IBaseGetItemsRequest
        
        switch request {
        case is GetChildrenRequest:
            result = self.mergeGetChildrenRequest(request as! IGetChildrenRequest)
        case is GetByPathRequest:
            result = self.mergeGetByPathRequest(request as! IGetByPathRequest)
        case is StoredQueryRequest:
            result = self.mergeStoredQueryRequestRequest(request as! IStoredSitecoreSearchRequest)
        default:
            print("Type not found request not merged")
            result = request
        }
        
        return result
    }
    
    public func mergeGetChildrenRequest(_ request: IGetChildrenRequest) -> GetChildrenRequest
    {
        let autocompletedRequest = GetChildrenRequest(
            parentId: request.parentId.uuidString,
            pagingParameters: request.pagingParameters,
            itemSource: request.itemSource,
            sessionConfig: self.sessionConfig,
            standardFields: request.includeStandardTemplateFields,
            ignoreCache: request.ignoreCache
        )
        
        autocompletedRequest.fields = request.fields
        
        return autocompletedRequest
    }
    
    public func mergeGetByPathRequest(_ request: IGetByPathRequest) -> GetByPathRequest
    {
        let autocompletedRequest = GetByPathRequest(
            itemPath: request.itemPath,
            itemSource: request.itemSource,
            sessionConfig: self.sessionConfig,
            standardFields: request.includeStandardTemplateFields
        )
        
        autocompletedRequest.fields = request.fields
        
        return autocompletedRequest
    }
    
    public func mergeGetByIdRequest(_ request: IGetByIdRequest) -> GetByIdRequest
    {
        let autocompletedRequest = GetByIdRequest(
            itemId: request.itemId.uuidString,
            itemSource: request.itemSource,
            sessionConfig: self.sessionConfig,
            standardFields: request.includeStandardTemplateFields
        )
        
        autocompletedRequest.fields = request.fields
        
        return autocompletedRequest
    }

    public func mergeStoredQueryRequestRequest(_ request: IStoredSitecoreSearchRequest) -> StoredQueryRequest
    {
        let autocompletedRequest = StoredQueryRequest(
            itemId: request.itemId.uuidString,
            pagingParameters: request.pagingParameters,
            itemSource: request.itemSource,
            sessionConfig: self.sessionConfig,
            standardFields: request.includeStandardTemplateFields
        )
        
        autocompletedRequest.fields = request.fields
        
        return autocompletedRequest
    }
    
}
