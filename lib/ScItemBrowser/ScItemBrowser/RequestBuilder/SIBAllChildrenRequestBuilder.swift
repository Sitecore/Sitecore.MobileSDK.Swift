//
//  SIBAllChildrenRequestBuilder.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 12/14/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

public class SIBAllChildrenRequestBuilder: NSObject, SCItemsLevelRequestBuilder
{
    public override init()
    {
        
    }
    
    public func itemsBrowser(_ sender: Any, levelDownRequestFor item: ISitecoreItem, ignoreCache: Bool) -> IBaseGetItemsRequest
    {
        let request: GetChildrenRequest = GetChildrenRequest(parentId: item.id,
                                                             pagingParameters: nil,
                                                             itemSource: item.source!,
                                                             sessionConfig: nil,
                                                             standardFields: true,
                                                             ignoreCache: ignoreCache)
        return request
    }

}
