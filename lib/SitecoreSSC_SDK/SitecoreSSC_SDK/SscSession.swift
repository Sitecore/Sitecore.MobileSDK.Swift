//
//  SscSession.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/22/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

public typealias SCDidFinishItemsRequestHandler = (IItemsResponse?, SscError?) -> ()
public typealias SCDidFinishImageRequestHandler = (UIImage?, SscError?) -> ()
public typealias SCDidFinishMediaDownloadingHandler = (UIImage?, SscError?) -> ()

public class SscSession : NSObject, URLSessionDelegate
{
    private let sessionConfig: ISessionConfig
    private let requestSyntax: ISscUrlParameters = ItemSSCV1UrlParameters()
    private let urlSession: URLSession
    private let requestMerger: RequestMerger
    private let odataApiKey: UUID! = nil
    
    private var activeUser: String? = nil
    private let credentialsStorage = CredentialsStorage()
    
    
    public init(url: String, urlSession: URLSession)
    {
        self.sessionConfig = SessionConfig(url: url, requestSyntax: requestSyntax)
        self.urlSession = urlSession
        self.urlSession.configuration.requestCachePolicy = .returnCacheDataElseLoad
        self.requestMerger = RequestMerger(sessionConfig: self.sessionConfig)
    }
    
    public convenience init(url: String, urlSession: URLSession, autologinCredentials: IScCredentials)
    {
        self.init(url: url, urlSession: urlSession)
        self.enableAutologinWithCredentials(autologinCredentials)
    }

}

extension SscSession: ISscAuthSession
{
    public func sendLoginRequest(_ request: ILoginRequest, completion: @escaping (ILoginResponse?, SscError?) -> ())
    {
        //TODO: @igk check for authentication
        // self.proceedLoginAction()
        
        let autocompletedRequest = LoginRequest(credentils: request.credentials, sessionConfig: self.sessionConfig)
        
        RequestExecutor.executePostRequest(autocompletedRequest, session: self.urlSession) { (response: LoginResponse?, error) in
            
            guard error == nil else
            {
                completion(nil, error)
                return
            }
            
            completion(response, nil)
        }
        
    }
    
    func sendLogoutRequest(_ request: ILogoutRequest, completion:@escaping (ILogoutResponse?, SscError?) -> ())
    {
        
    }
    
    public func enableAutologinWithCredentials(_ credentials: IScCredentials)
    {
        self.activeUser = credentials.username
        self.credentialsStorage.removePassword(for: self.activeUser!)
        self.credentialsStorage.setPassword(credentials.password, for: self.activeUser!)
    }
    
    func disableAutologin()
    {
        guard let activeUser = self.activeUser else
        {
            print("Autologin was not enabled")
            return
        }
        
        self.credentialsStorage.removePassword(for: activeUser)
        self.activeUser = nil
    }
    
    func autologin(completion: @escaping ()->())
    {
        if (self.UserIsLoggedIn)
        {
            completion()
            return
        }
        
        if (AutologinIsActive)
        {
            let password = self.credentialsStorage.getPassword(for: self.activeUser!)
            let credentials = ScCredentials(username: self.activeUser!, password: password!, domain: "Sitecore")
            
            let loginRequest = LoginRequest(credentils: credentials)
            
            self.sendLoginRequest(loginRequest) { (response, error) in
                completion()
            }
        }
        else
        {
            completion()
        }
    }

    var AutologinIsActive: Bool
    {
        get
        {
            if (self.activeUser != nil)
            {
                return true
            }
            
            return false
        }
    }
    
    var UserIsLoggedIn: Bool
    {
        get
        {
            let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: self.sessionConfig.instanceUrl)!)
            let currentDate = Date()
            for cookie in cookies!
            {
                #warning("@igk extract to some king of cookie checker")
                let isAuthCookie: Bool = (".ASPXAUTH" == cookie.name) || (".AspNet.Cookies" == cookie.name)

                if ( isAuthCookie && cookie.expiresDate! > currentDate)
                {
                    return true
                }
            }
            
            return false
        }
    }
    
    
    
}

extension SscSession: ISscReadOnlySession
{
    public func downloadImageForItem(_ item: ISitecoreItem, completion: DataDownloadingProcessing)
    {
        let imageRequest = GetImageRequest(mediaItem: item, sessionConfig: self.sessionConfig)

        ScImageLoader.getImageWithRequest(imageRequest, session: self.urlSession, completion: completion)
    }

    public func sendGetItemsRequest(_ request: IGetByPathRequest, completion: @escaping SCDidFinishItemsRequestHandler)
    {
        self.autologin
        {
            let autocompletedRequest = self.requestMerger.mergeGetByPathRequest(request)
            
            RequestExecutor.executeGetRequest(autocompletedRequest, session: self.urlSession) { (response, error) in
                self.proceedGetItemsResponse(response, error: error, completion: completion)
            }

        }
    }
    
    public func sendGetItemsRequest(_ request: IBaseGetItemsRequest, completion: @escaping SCDidFinishItemsRequestHandler)
    {
        self.autologin
        {
            let autocompletedRequest = self.requestMerger.mergeGetRequest(request)
            
            RequestExecutor.executeGetRequest(autocompletedRequest, session: self.urlSession) { (response, error) in
                self.proceedGetItemsResponse(response, error: error, completion: completion)
            }
        }
    }
    
    public func sendGetItemsRequest(_ request: IGetChildrenRequest, completion: @escaping SCDidFinishItemsRequestHandler)
    {
        self.autologin
        {
            let autocompletedRequest = self.requestMerger.mergeGetChildrenRequest(request)
            
            RequestExecutor.executeGetRequest(autocompletedRequest, session: self.urlSession) { (response, error) in
                self.proceedGetItemsResponse(response, error: error, completion: completion)
            }
        }
    }
    
    func sendGetItemsRequest(_ request: ISitecoreSearchRequest, completion: @escaping SCDidFinishItemsRequestHandler)
    {
        
    }
    
    func sendGetItemsRequest(_ request: IStoredSitecoreSearchRequest, completion: @escaping SCDidFinishItemsRequestHandler)
    {
        self.autologin
            {
                let autocompletedRequest = self.requestMerger.mergeStoredQueryRequestRequest(request)
                
                RequestExecutor.executeGetRequest(autocompletedRequest, session: self.urlSession) { (response, error) in
                    self.proceedGetItemsResponse(response, error: error, completion: completion)
                }
        }
    }
    
    public func sendGetItemsRequest(_ request: IGetByIdRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    {
        self.autologin
        {
            let autocompletedRequest = self.requestMerger.mergeGetByIdRequest(request)
            
            RequestExecutor.executeGetRequest(autocompletedRequest, session: self.urlSession) { (response, error) in
                self.proceedGetItemsResponse(response, error: error, completion: completion)
            }
        }
    }
    
    private func proceedGetItemsResponse(_ response: IItemsResponse?, error: SscError?, completion: SCDidFinishItemsRequestHandler)
    {
        guard error == nil else
        {
            completion(nil, error)
            return
        }
        
        completion(response, nil)
    }
  
}

extension SscSession: ISscOdataSession
{
    func SetOdataApiKey(_key: UUID)
    {
        
    }
    
    func sendOdataRequest(_ request: IOdataRequest, completion: @escaping SCDidFinishItemsRequestHandler)
    {
        
    }    
}

protocol ISscOdataSession
{
    
    func SetOdataApiKey(_key: UUID)
    func sendOdataRequest(_ request: IOdataRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    
}


protocol ISscAuthSession
{
    func enableAutologinWithCredentials(_ credentials: IScCredentials)
    func sendLoginRequest(_ request: ILoginRequest, completion:@escaping (ILoginResponse?, SscError?) -> ())
    func sendLogoutRequest(_ request: ILogoutRequest, completion:@escaping (ILogoutResponse?, SscError?) -> ())
    
}

protocol ISscReadOnlySession
{
    func sendGetItemsRequest(_ request: IGetByIdRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(_ request: IGetByPathRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(_ request: IGetChildrenRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(_ request: IBaseGetItemsRequest, completion: @escaping SCDidFinishItemsRequestHandler)
    
    func sendGetItemsRequest(_ request: ISitecoreSearchRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(_ request: IStoredSitecoreSearchRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    
    func downloadImageForItem(_ item: ISitecoreItem, completion: DataDownloadingProcessing)
}

