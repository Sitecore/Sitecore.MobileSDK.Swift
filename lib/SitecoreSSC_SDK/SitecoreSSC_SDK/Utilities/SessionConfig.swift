//
//  SessionConfig.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/26/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

@objc public protocol ISessionConfig
{
    var instanceUrl: String { get }
    var requestSyntax: ISscUrlParameters { get } //TODO: @igk make it private
}

class SessionConfig: ISessionConfig
{
    let instanceUrl: String
    let requestSyntax: ISscUrlParameters
    
    init (url: String, requestSyntax: ISscUrlParameters){
        self.instanceUrl = url
        self.requestSyntax = requestSyntax
    }
    
}
