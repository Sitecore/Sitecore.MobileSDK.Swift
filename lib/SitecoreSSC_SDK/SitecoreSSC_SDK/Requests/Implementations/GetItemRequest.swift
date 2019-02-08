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
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        standardFields: Bool
        )
    {
        self.itemId = UUID(uuidString: itemId)!
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, standardFields: standardFields)
    }
    
    public override func buildUrlString() -> String {
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
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        standardFields: Bool
        )
    {
        self.itemPath = itemPath
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, standardFields: standardFields)
    }

    public override func buildUrlString() -> String
    {
        let url = sessionConfig!.instanceUrl
            + sessionConfig!.requestSyntax.ItemSSCEndpoint
            + sessionConfig!.requestSyntax.ItemSSCItemsEndpoint
        
        return url
    }
   
    public override func buildUrlParametersString() -> String?
    {
        let baseParameters = super.buildUrlParametersString()
        
        let escapedPath: String = self.itemPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        var parameters = sessionConfig!.requestSyntax.ItemPathParameterName
            + sessionConfig!.requestSyntax.urlParmeterAssignSign
            + escapedPath
            
        if (baseParameters != nil)
        {
            parameters = parameters + sessionConfig!.requestSyntax.urlParametersSeparator
                                    + baseParameters!
        }
        
        return parameters
    }
}

public class GetChildrenRequest: BaseGetItemRequest, IGetChildrenRequest
{
    public let parentId: UUID
    
    public let pagingParameters: IPagingParameters?
    
    public init(
        parentId: String,
        pagingParameters: IPagingParameters?,
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        standardFields: Bool,
        ignoreCache: Bool
        )
    {
        self.parentId = UUID(uuidString: parentId)!
        self.pagingParameters = pagingParameters
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, standardFields: standardFields, ignoreCache: ignoreCache)
    }
    
    public override func buildUrlString() -> String
    {
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

