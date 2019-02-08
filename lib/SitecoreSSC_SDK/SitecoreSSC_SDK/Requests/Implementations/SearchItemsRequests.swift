//
//  SearchItemsRequests.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 2/8/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

public class StoredQueryRequest: BasePaggedGetItemRequest, IStoredSitecoreSearchRequest
{
    public var itemId: UUID
    
    public init(
        itemId: String,
        pagingParameters: IPagingParameters?,
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        standardFields: Bool
        )
    {
        self.itemId = UUID(uuidString: itemId)!
        super.init(pagingParameters: pagingParameters, itemSource: itemSource, sessionConfig: sessionConfig, standardFields: standardFields)
    }
    
    public override func buildUrlString() -> String
    {
        guard let sessionConfig = self.sessionConfig else
        {
            #warning ("@igk proceed error!!!")
            return ""
        }
        
        let url = sessionConfig.instanceUrl
            + sessionConfig.requestSyntax.ItemSSCEndpoint
            + sessionConfig.requestSyntax.ItemSSCItemsEndpoint
            + sessionConfig.requestSyntax.urlPathSeparator
            + self.itemId.uuidString
            + sessionConfig.requestSyntax.SitecoreQueryParameterName
        
        return url
    }

}
 
