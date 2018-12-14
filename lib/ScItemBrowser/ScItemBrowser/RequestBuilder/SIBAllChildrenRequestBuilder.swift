//
//  SIBAllChildrenRequestBuilder.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 12/14/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

public class SIBAllChildrenRequestBuilder: SCItemsLevelRequestBuilder
{
    public init()
    {
        
    }
    
    public func itemsBrowser(_ sender: Any, levelDownRequestFor item: ISitecoreItem) -> IGetChildrenRequest
    {
        let request: GetChildrenRequest = GetChildrenRequest(parentId: item.id,
                                                             pagingParameters: nil,
                                                             itemSource: item.source!,
                                                             sessionConfig: nil,
                                                             queryParameters: nil,
                                                             standardFields: true)
        return request
    }

}
