//
//  RequestExecutor.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/26/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

enum RequestExecutorError: Error {
    case nilDataError
}

protocol IRequestExecutor {
    
    static func executeGetRequest<T: IBaseGetItemsRequest, R: IItemsResponse>(_ dumpT: T.Type, _ dumpR: R.Type, _ parameters: T, session: URLSession, completion: @escaping (R?, Error?) -> () )
    
    static func executePostRequest<T: IBasePostRequest, R: IBaseResponse>(_ dumpT: T.Type, _ dumpR: R.Type, _ parameters: T, session: URLSession, completion: @escaping (R?, Error?) -> () )
}

class RequestExecutor: IRequestExecutor {
    
    
    
    static func executeGetRequest<T: IBaseGetItemsRequest, R: IItemsResponse>(_ dumpT: T.Type, _ dumpR: R.Type, _ parameters: T, session: URLSession, completion: @escaping (R?, Error?) -> () )
    {
        var request: URLRequest
        
        do {
            request = try parameters.buildHTTPRequest()
        } catch {
            completion(nil, error)
            return
        }
        
        
        let task = session.dataTask(with: request) { data, response, error in
            
            //TODO: @igk some king of check should be here
            
            guard let data = data else {
                print("something went wrong")
                completion(nil, RequestExecutorError.nilDataError)
                return
            }
            
            let result = R(json: data, source: parameters.itemSource)
            completion(result, nil)
        }
        
        task.resume()
        
        
    }
    
    static func executePostRequest<T: IBasePostRequest, R: IBaseResponse>(_ dumpT: T.Type, _ dumpR: R.Type, _ parameters: T, session: URLSession, completion: @escaping (R?, Error?) -> () )
    {
        var request: URLRequest
        
        do {
            request = try parameters.buildHTTPRequest()
        } catch {
            completion(nil, error)
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.httpBody = parameters.buildRequestBody()
        
        let task = session.dataTask(with: request) { data, response, error in
            
            //TODO: @igk some king of check should be here
            
            guard let data = data else {
                print("something went wrong")
                completion(nil, RequestExecutorError.nilDataError)
                return
            }
            
            let result = R(json: data, source: nil)
            
            let cookies: [HTTPCookie]?
            let rp = response as! HTTPURLResponse
            if let responseHeaders = rp.allHeaderFields as? [String:String] {
                cookies = HTTPCookie.cookies(withResponseHeaderFields: responseHeaders, for:rp.url!)
                HTTPCookieStorage.shared.setCookies(cookies!, for: response!.url!, mainDocumentURL: nil)
                print("LOGIN COOKIES: \(String(describing: cookies))")
            }
            
            completion(result, nil)
        }
        
        task.resume()
        
        
    }
    
}

