//
//  File.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/29/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

enum SscError: Error {
    case runtimeError(String)
}

class ErrorDescriptions
{
    static func canNotBuilUrlFor(_ request: String) -> String
    {
       return "Can not build url for \(request) request"
    }
    
    
}


//func someFunction() throws {
//    throw SscError("some message")
//}
//do {
//    try someFunction()
//} catch SscError.runtimeError(let errorMessage) {
//    print(errorMessage)
//}
