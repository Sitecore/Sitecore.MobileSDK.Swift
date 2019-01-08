//
//  RequestExecutor.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/26/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

protocol IRequestExecutor {
    
    static func executePostRequest<T: IBaseResponse>(_ parameters: IBasePostRequest, session: URLSession, completion: @escaping (T?, SscError?) -> () )

    static func executeGetRequest(_ parameters: IBaseGetItemsRequest, session: URLSession, completion: @escaping (IItemsResponse?, SscError?) -> () )

}

class RequestExecutor: IRequestExecutor {
    
    static func executeGetRequest(_ parameters: IBaseGetItemsRequest, session: URLSession, completion: @escaping (IItemsResponse?, SscError?) -> () )
    {
        var request: URLRequest
        
        do {
            request = try parameters.buildHTTPRequest()
        } catch {
            completion(nil, SscError.unknownNetworkError(error.localizedDescription))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if (error != nil) {
                completion(nil, SscError.networkError(error))
                return
            }
            
            guard let data = data else {
                print("something went wrong")
                completion(nil, SscError.unknownNetworkError("status code: \(String(describing: response?.statusCode))"))
                return
            }
            
            let result = ItemsResponse(json: data, source: parameters.itemSource)
            completion(result, nil)
        }
        
        task.resume()
        
    }
    
    static func executePostRequest<T: IBaseResponse>(_ parameters: IBasePostRequest, session: URLSession, completion: @escaping (T?, SscError?) -> () )
    {
        var request: URLRequest
        
        do {
            request = try parameters.buildHTTPRequest()
        } catch {
            completion(nil, SscError.requesBuilderError(error))
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.httpBody = parameters.buildRequestBody()
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if (error != nil) {
                completion(nil, SscError.networkError(error))
                return
            }
            
            guard let data = data else {
                print("something went wrong")
                completion(nil, SscError.unknownNetworkError("status code: \(String(describing: response?.statusCode))"))
                return
            }
            
            let result = T(json: data, source: nil)
            
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

extension URLResponse {
    
    var statusCode: Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
