//
//  File.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/26/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

public class GetByIdRequest: BaseGetItemRequest, IGetByIdRequest
{
    public let itemId: UUID

    public init(
        itemId: String,
        itemSource: IItemSource,
        sessionConfig: ISessionConfig?,
        queryParameters: IQueryParameters?,
        standardFields: Bool
        )
    {
        self.itemId = UUID(uuidString: itemId)!
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, queryParameters: queryParameters, standardFields: standardFields)
    }
    
    public override func buildUrl() -> String {
        let url = sessionConfig!.instanceUrl
            + sessionConfig!.requestSyntax.ItemSSCEndpoint
            + sessionConfig!.requestSyntax.ItemSSCItemsEndpoint
            + sessionConfig!.requestSyntax.urlPathSeparator
            + self.itemId.uuidString
        
        return url
    }
}

public class GetByPathRequest: BaseGetItemRequest, IGetByPathRequest
{
    public let itemPath: String
    
    public init(
        itemPath: String,
        itemSource: IItemSource,
        sessionConfig: ISessionConfig?,
        queryParameters: IQueryParameters?,
        standardFields: Bool
        )
    {
        self.itemPath = itemPath
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, queryParameters: queryParameters, standardFields: standardFields)
    }

    public override func buildUrl() -> String {
        
        let escapedPath: String = self.itemPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let url = sessionConfig!.instanceUrl
            + sessionConfig!.requestSyntax.ItemSSCEndpoint
            + sessionConfig!.requestSyntax.ItemSSCItemsEndpoint
            + sessionConfig!.requestSyntax.urlPathAndParametersSeparator
            + sessionConfig!.requestSyntax.ItemPathParameterName
            + sessionConfig!.requestSyntax.urlParmeterAssignSign
            + escapedPath
        
        return url
    }
   
}

public class GetChildrenRequest: BaseGetItemRequest, IGetChildrenRequest
{
    public let parentId: UUID
    
    public let pagingParameters: IPagingParameters?
    
    public init(
        parentId: String,
        pagingParameters: IPagingParameters?,
        itemSource: IItemSource,
        sessionConfig: ISessionConfig?,
        queryParameters: IQueryParameters?,
        standardFields: Bool
        )
    {
        self.parentId = UUID(uuidString: parentId)!
        self.pagingParameters = pagingParameters
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, queryParameters: queryParameters, standardFields: standardFields)
    }
    
    public override func buildUrl() -> String {
        let url = sessionConfig!.instanceUrl
            + sessionConfig!.requestSyntax.ItemSSCEndpoint
            + sessionConfig!.requestSyntax.ItemSSCItemsEndpoint
            + sessionConfig!.requestSyntax.urlPathSeparator
            + self.parentId.uuidString
            + sessionConfig!.requestSyntax.urlPathSeparator
            + sessionConfig!.requestSyntax.ItemSSCChildrenAction
        
        return url
    }
}

public class BaseGetItemRequest: IBaseGetItemsRequest
{
    public let itemSource: IItemSource
    public let queryParameters: IQueryParameters?
    public let includeStandardTemplateFields: Bool
    public let sessionConfig: ISessionConfig?
    
    public init(
        itemSource: IItemSource,
        sessionConfig: ISessionConfig?,
        queryParameters: IQueryParameters?,
        standardFields: Bool
        )
    {
        //TODO: @igk check all input data
        self.itemSource = itemSource
        self.sessionConfig = sessionConfig
        self.queryParameters = queryParameters
        self.includeStandardTemplateFields = standardFields
    }
    
    public func buildUrl() -> String {
        return ""
    }
    
    public func buildHTTPRequest() -> URLRequest {
        //TODO: @igk check for errors
        let urlString = self.buildUrl()
        return URLRequest(url: URL(string: urlString)!)
    }
}
