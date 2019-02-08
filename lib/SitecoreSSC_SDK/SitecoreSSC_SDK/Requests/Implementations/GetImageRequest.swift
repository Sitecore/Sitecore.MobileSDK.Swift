//
//  GetImageRequest.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 1/3/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

class GetImageRequest: IGetImageRequest
{
    public var mediaItem: ISitecoreItem
    public let ignoreCache: Bool
    public let sessionConfig: ISessionConfig?
    
    public init(
        mediaItem: ISitecoreItem,
        sessionConfig: ISessionConfig?,
        ignoreCache: Bool = false
        )
    {
        #warning ("@igk check all input data")
        self.mediaItem = mediaItem
        self.sessionConfig = sessionConfig
        self.ignoreCache = ignoreCache
    }
    
    func buildUrlParametersString() -> String? {
        return nil
    }
    
    public func buildUrlString() -> String?
    {
        let url = sessionConfig!.instanceUrl
        let imagePath = self.mediaItem.fields["ItemMedialUrl"]! as! String
        
        return "\(url)/\(imagePath)"
    }
}
