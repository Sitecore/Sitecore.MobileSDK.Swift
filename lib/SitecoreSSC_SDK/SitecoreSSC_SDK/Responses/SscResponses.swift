//
//  SscResponses.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/22/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation


public protocol IBaseResponse {
    
    func isSuccessful() -> Bool
    
    init(json: Data, source: IItemSource?, sessionConfig: ISessionConfig?) 
    
}

public protocol ILoginResponse: IBaseResponse {
    
}

public protocol ILogoutResponse: IBaseResponse {
    
}

public protocol IItemsResponse: IBaseResponse {
    
    var items: [ISitecoreItem] { get }
    
}
