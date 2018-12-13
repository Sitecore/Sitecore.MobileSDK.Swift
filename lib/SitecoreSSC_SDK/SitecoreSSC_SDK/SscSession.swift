//
//  SscSession.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/22/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

public typealias SCDidFinishItemsRequestHandler = (IItemsResponse?, Error?) -> ()


public class SscSession : NSObject, URLSessionDelegate
{
    private let sessionConfig: ISessionConfig
    private let requestSyntax: ISscUrlParameters = ItemSSCV1UrlParameters()
    private let urlSession: URLSession
    
    public init(url: String, urlSession: URLSession) {
        
        sessionConfig = SessionConfig(url: url, requestSyntax: requestSyntax)
        self.urlSession = urlSession
    }

}

extension SscSession: ISscAuthSession
{
    public func sendLoginRequest(request: ILoginRequest, completion: @escaping (ILoginResponse?, Error?) -> ()) {
        //TODO: @igk check for authentication
        // self.proceedLoginAction()
        
        //TODO: @igk complete request with default values
        //let autoCompletedRequest: IGetByIdRequest = self.requestMerger.FillReadItemByIdGaps(requestCopy)
        
        
        //        let urlBuilder = ItemByIdUrlBuilder(self.requestSyntax);
        //        let taskFlow = GetItemsByIdTasks(urlBuilder);
        
        //
        let autocompletedRequest = LoginRequest(credentils: request.credentils, sessionConfig: self.sessionConfig)
        
        RequestExecutor.executePostRequest(LoginRequest.self, LoginResponse.self, autocompletedRequest, session: self.urlSession) { (response, error) in
            guard error == nil else {
                
                completion(nil, error)
                return
            }
            
            completion(response, nil)
        }
        
    }
    
    func sendLogoutRequest(request: ILogoutRequest, completion:@escaping (ILogoutResponse?, Error?) -> ()) {
        
    }

    
}

extension SscSession: ISscReadOnlySession
{
    public func sendGetItemsRequest(request: IGetByPathRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        //TODO: @igk check for authentication
        // self.proceedLoginAction()
        
        //TODO: @igk complete request with default values
        //let autoCompletedRequest: IGetByIdRequest = self.requestMerger.FillReadItemByIdGaps(requestCopy)
        
        
        //        let urlBuilder = ItemByIdUrlBuilder(self.requestSyntax);
        //        let taskFlow = GetItemsByIdTasks(urlBuilder);
        
        //TODO: @igk make autocompletion
        let autocompletedRequest = GetByPathRequest(
            itemPath: request.itemPath,
            itemSource: request.itemSource,
            sessionConfig: self.sessionConfig,
            queryParameters: request.queryParameters,
            standardFields: request.includeStandardTemplateFields
        )
        
        RequestExecutor.executeGetRequest(GetByPathRequest.self, ItemsResponse.self, autocompletedRequest, session: self.urlSession) { (response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion(response, nil)
        }

    }
    
    public func sendGetItemsRequest(request: IGetChildrenRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        //TODO: @igk check for authentication
        // self.proceedLoginAction()
        
        //TODO: @igk complete request with default values
        //let autoCompletedRequest: IGetByIdRequest = self.requestMerger.FillReadItemByIdGaps(requestCopy)
        
        
        //        let urlBuilder = ItemByIdUrlBuilder(self.requestSyntax);
        //        let taskFlow = GetItemsByIdTasks(urlBuilder);
        
        //TODO: @igk make autocompletion
        let autocompletedRequest = GetChildrenRequest(
            parentId: request.parentId.uuidString,
            pagingParameters: request.pagingParameters,
            itemSource: request.itemSource,
            sessionConfig: self.sessionConfig,
            queryParameters: request.queryParameters,
            standardFields: request.includeStandardTemplateFields
        )
        
        RequestExecutor.executeGetRequest(GetChildrenRequest.self, ItemsResponse.self, autocompletedRequest, session: self.urlSession) { (response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion(response, nil)
        }
    }
    
    func sendGetItemsRequest(request: ISitecoreSearchRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        
    }
    
    func sendGetItemsRequest(request: IStoredSitecoreSearchRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        
    }
    
    public func sendGetItemsRequest(request: IGetByIdRequest, completion:@escaping SCDidFinishItemsRequestHandler){
        
        //TODO: @igk check for authentication
        // self.proceedLoginAction()
        
        //TODO: @igk complete request with default values
        //let autoCompletedRequest: IGetByIdRequest = self.requestMerger.FillReadItemByIdGaps(requestCopy)
        
        
        //        let urlBuilder = ItemByIdUrlBuilder(self.requestSyntax);
        //        let taskFlow = GetItemsByIdTasks(urlBuilder);
        
        //TODO: @igk make autocompletion
        let autocompletedRequest = GetByIdRequest(
            itemId: request.itemId.uuidString,
            itemSource: request.itemSource,
            sessionConfig: self.sessionConfig,
            queryParameters: request.queryParameters,
            standardFields: request.includeStandardTemplateFields
        )
        
        RequestExecutor.executeGetRequest(GetByIdRequest.self, ItemsResponse.self, autocompletedRequest, session: self.urlSession) { (response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion(response, nil)
        }

    }
    
    
  
}



protocol ISscAuthSession {
    
    func sendLoginRequest(request: ILoginRequest, completion:@escaping (ILoginResponse?, Error?) -> ())
    func sendLogoutRequest(request: ILogoutRequest, completion:@escaping (ILogoutResponse?, Error?) -> ())
    
}

protocol ISscReadOnlySession {
    
    func sendGetItemsRequest(request: IGetByIdRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(request: IGetByPathRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(request: IGetChildrenRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    
    func sendGetItemsRequest(request: ISitecoreSearchRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(request: IStoredSitecoreSearchRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    
}

