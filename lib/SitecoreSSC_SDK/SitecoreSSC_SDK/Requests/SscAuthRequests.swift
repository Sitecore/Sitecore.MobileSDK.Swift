//
//  SscAutentication.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/23/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

public class LoginRequest: ILoginRequest
{
    public let credentials: IScCredentials
    public let sessionConfig: ISessionConfig?

    public init(credentils: IScCredentials)
    {
        self.credentials = credentils
        self.sessionConfig = nil
    }
    
    internal init(credentils: IScCredentials, sessionConfig: ISessionConfig?)
    {
        self.credentials = credentils
        self.sessionConfig = sessionConfig
    }
    
    public func buildUrlParametersString() -> String?
    {
        return nil
    }
    
    public func buildRequestBody() -> Data {
        
        //TODO: @igk refactor this
        let body = "{\"domain\":\"\(self.credentials.domain)\",\"username\":\"\(self.credentials.username)\",\"password\":\"\(self.credentials.password)\"}"
        
        print("LOGIN REQUEST BODY:\(body)")
        
        return body.data(using: .utf8)!
    }

    public func buildHTTPRequest() throws -> URLRequest
    {

        guard let urlString = self.buildUrlString() else
        {
            throw SscError.runtimeError(ErrorDescriptions.canNotBuilUrlFor("AUTH request"))
        }
        
        print("AUTH REQUEST URL:\(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw SscError.runtimeError(ErrorDescriptions.canNotBuilUrlFor("AUTH request"))
        }
        
        return URLRequest(url: url)
    }
    
    public func buildUrlString() -> String? {
        
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
    
    var credentials: IScCredentials { get }
    
}


public protocol ILogoutRequest: IBaseRequest {
    
}
