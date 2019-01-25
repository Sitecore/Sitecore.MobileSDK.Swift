//
//  SscAutentication.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/23/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

public class LoginRequest: ILoginRequest {
    
    public init(credentils: IScCredentials)
    {
        self.credentils = credentils
        self.sessionConfig = nil
    }
    
    internal init(
        credentils: IScCredentials,
        sessionConfig: ISessionConfig
        )
    {
        self.credentils = credentils
        self.sessionConfig = sessionConfig
    }
    
    public let credentils: IScCredentials
    public let sessionConfig: ISessionConfig?
    
    public func buildRequestBody() -> Data {
        
        //TODO: @igk refactor this
        let body = "{\"domain\":\"\(self.credentils.domain)\",\"username\":\"\(self.credentils.username)\",\"password\":\"\(self.credentils.password)\"}"
        
        print("LOGIN REQUEST BODY:\(body)")
        
        return body.data(using: .utf8)!
    }

    public func buildHTTPRequest() throws -> URLRequest  {

        guard let urlString = self.buildUrl() else
        {
            throw SscError.runtimeError(ErrorDescriptions.canNotBuilUrlFor("AUTH request"))
        }
        
        print("AUTH REQUEST URL:\(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw SscError.runtimeError(ErrorDescriptions.canNotBuilUrlFor("AUTH request"))
        }
        
        return URLRequest(url: url)
    }
    
    public func buildUrl() -> String? {
        
        guard let sessionConfig = self.sessionConfig else
        {
            return nil
        }
        
        let url = sessionConfig.instanceUrl
            + sessionConfig.requestSyntax.ItemSSCEndpoint
            + sessionConfig.requestSyntax.ItemSSCAuthEndpoint
            + sessionConfig.requestSyntax.ItemSSCLoginAction
        
        return url
    }
    
}


public protocol ILoginRequest: IBasePostRequest {
    
    var credentils: IScCredentials { get }
    
}


public protocol ILogoutRequest: IBaseRequest {
    
}
