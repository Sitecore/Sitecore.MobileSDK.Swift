//
//  File.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/29/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

public enum SscError: Error {
    case runtimeError(String)
    case requesBuilderError(Error)
    case unknownNetworkError(String)
    case networkError(Error?)
}

public class ErrorDescriptions
{
    static func canNotBuilUrlFor(_ request: String) -> String
    {
       return "Can not build url for \(request) request"
    }
    
    static func unknownNetworkError(userInfo: String) -> String
    {
        return "Unknown network error, user info: \(userInfo)"
    }
    
    static func requesBuilderErrorError(userInfo: String) -> String
    {
        return "Can not build request, user info: \(userInfo)"
    }
}
