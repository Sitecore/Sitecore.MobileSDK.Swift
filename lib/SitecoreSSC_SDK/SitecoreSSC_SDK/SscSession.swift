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
    
    public init(url: String, urlSession: URLSession) {
        
        self.sessionConfig = SessionConfig(url: url, requestSyntax: requestSyntax)
        self.urlSession = urlSession
        self.urlSession.configuration.requestCachePolicy = .returnCacheDataElseLoad
        self.requestMerger = RequestMerger(sessionConfig: self.sessionConfig)
    }

}

extension SscSession: ISscAuthSession
{
    public func sendLoginRequest(_ request: ILoginRequest, completion: @escaping (ILoginResponse?, SscError?) -> ()) {
        //TODO: @igk check for authentication
        // self.proceedLoginAction()
        
        //TODO: @igk complete request with default values
        //let autoCompletedRequest: IGetByIdRequest = self.requestMerger.FillReadItemByIdGaps(requestCopy)
        
        
        //        let urlBuilder = ItemByIdUrlBuilder(self.requestSyntax);
        //        let taskFlow = GetItemsByIdTasks(urlBuilder);
        
        //
        let autocompletedRequest = LoginRequest(credentils: request.credentils, sessionConfig: self.sessionConfig)
        
        RequestExecutor.executePostRequest(autocompletedRequest, session: self.urlSession) { (response: LoginResponse?, error) in
            guard error == nil else {
                
                completion(nil, error)
                return
            }
            
            completion(response, nil)
        }
        
    }
    
    func sendLogoutRequest(_ request: ILogoutRequest, completion:@escaping (ILogoutResponse?, SscError?) -> ())
    {
        
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
        //TODO: @igk check for authentication
        // self.proceedLoginAction()
        
        //TODO: @igk complete request with default values
        //let autoCompletedRequest: IGetByIdRequest = self.requestMerger.FillReadItemByIdGaps(requestCopy)
        
        
        //        let urlBuilder = ItemByIdUrlBuilder(self.requestSyntax);
        //        let taskFlow = GetItemsByIdTasks(urlBuilder);
        
        //TODO: @igk make autocompletion
        let autocompletedRequest = self.requestMerger.mergeGetByPathRequest(request)
        
        RequestExecutor.executeGetRequest(autocompletedRequest, session: self.urlSession) { (response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion(response, nil)
        }

    }
    
    public func sendGetItemsRequest(_ request: IBaseGetItemsRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        
        let autocompletedRequest = self.requestMerger.mergeGetRequest(request)
        
        RequestExecutor.executeGetRequest(autocompletedRequest, session: self.urlSession) { (response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion(response, nil)
        }
        
    }
    
    public func sendGetItemsRequest(_ request: IGetChildrenRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        //TODO: @igk check for authentication
        // self.proceedLoginAction()
        
        //TODO: @igk complete request with default values
        //let autoCompletedRequest: IGetByIdRequest = self.requestMerger.FillReadItemByIdGaps(requestCopy)
        
        
        //        let urlBuilder = ItemByIdUrlBuilder(self.requestSyntax);
        //        let taskFlow = GetItemsByIdTasks(urlBuilder);
        
        //TODO: @igk make autocompletion
        let autocompletedRequest = self.requestMerger.mergeGetChildrenRequest(request)
        
        RequestExecutor.executeGetRequest(autocompletedRequest, session: self.urlSession) { (response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion(response, nil)
        }
    }
    
    func sendGetItemsRequest(_ request: ISitecoreSearchRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        
    }
    
    func sendGetItemsRequest(_ request: IStoredSitecoreSearchRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        
    }
    
    public func sendGetItemsRequest(_ request: IGetByIdRequest, completion:@escaping SCDidFinishItemsRequestHandler){
        
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
        
        RequestExecutor.executeGetRequest(autocompletedRequest, session: self.urlSession) { (response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion(response, nil)
        }

    }
  
}

extension SscSession: ISscOdataSession
{
    func SetOdataApiKey(_key: UUID) {
        
    }
    
    func sendOdataRequest(_ request: IOdataRequest, completion: @escaping SCDidFinishItemsRequestHandler) {
        
    }
    
    
}

protocol ISscOdataSession {
    
    func SetOdataApiKey(_key: UUID)
    func sendOdataRequest(_ request: IOdataRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    
}


protocol ISscAuthSession {
    
    func sendLoginRequest(_ request: ILoginRequest, completion:@escaping (ILoginResponse?, SscError?) -> ())
    func sendLogoutRequest(_ request: ILogoutRequest, completion:@escaping (ILogoutResponse?, SscError?) -> ())
    
}

protocol ISscReadOnlySession {
    
    func sendGetItemsRequest(_ request: IGetByIdRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(_ request: IGetByPathRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(_ request: IGetChildrenRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(_ request: IBaseGetItemsRequest, completion: @escaping SCDidFinishItemsRequestHandler)
    
    func sendGetItemsRequest(_ request: ISitecoreSearchRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    func sendGetItemsRequest(_ request: IStoredSitecoreSearchRequest, completion:@escaping SCDidFinishItemsRequestHandler)
    
    func downloadImageForItem(_ item: ISitecoreItem, completion: DataDownloadingProcessing)

    
}

