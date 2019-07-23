
import Foundation

class RequestExecutor
{
    //MARK: -
    //MARK: GET
    
    static private func executeGetRequest(
        _ parameters: IBaseGetItemsRequest,
        pagingParameters: IPagingParameters?,
        parser: IResponseParser,
        session: URLSession,
        completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        guard let request: URLRequest = try? parameters.buildHTTPRequest() else
        {
            completion(.failure(.badRequest("can not build request: unknown")))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if (error != nil)
            {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else
            {
                completion(.failure(.networkErrorWithStatusCode("status code: \(String(describing: response?.httpStatusCode))")))
                return
            }
            
            let itemsList = parser.parseData(data: data, sessionConfig: parameters.sessionConfig, source: parameters.itemSource)
            
            let result = ItemsResponse(
                items: itemsList,
                statusCode: response?.httpStatusCode ?? 0,
                pagingParameters: pagingParameters
            )
            
            completion(.success(result))
        }
        
        task.resume()
    }
    
    static func executeGetRequest(
        _ parameters: IBaseGetItemsRequest,
        parser: IResponseParser,
        session: URLSession,
        completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        RequestExecutor.executeGetRequest(parameters,
                                          pagingParameters: nil,
                                          parser: parser,
                                          session: session,
                                          completion: completion)
    }
    
    static func executePaginatedRequest(
        _ parameters: IBaseGetPaginatedItemsRequest,
        parser: IResponseParser,
        session: URLSession,
        completion: @escaping (Result<IItemsResponse?, SSCError>) -> ()
        )
    {
        RequestExecutor.executeGetRequest(parameters,
                                          pagingParameters: parameters.pagingParameters,
                                          parser: parser,
                                          session: session,
                                          completion: completion)
    }
    
    //MARK: -
    //MARK: POST
    
    static func executeCreateRequest(_ parameters: ICreateRequest, session: URLSession, completion: @escaping (Result<CreateResponse?, SSCError>) -> ())
    {
        RequestExecutor.executeRawRequest(parameters, httpMethod: "POST", session: session, completion: completion)
    }
    
    static func executeAuthRequest(_ parameters: IBasePostRequest, session: URLSession, completion: @escaping (Result<AuthResponse?, SSCError>) -> ())
    {
        RequestExecutor.executeRawRequest(parameters, httpMethod: "POST", session: session, completion: completion)
    }
    
    static func executePatchRequest(_ parameters: IEditRequest, session: URLSession, completion: @escaping (Result<UpdateResponse?, SSCError>) -> ())
    {
        RequestExecutor.executeRawRequest(parameters, httpMethod: "PATCH", session: session, completion: completion)
    }
    
    static func executeDeleteRequest(_ parameters: IDeleteItemRequest, session: URLSession, completion: @escaping (Result<DeleteResponse?, SSCError>) -> ())
    {
        RequestExecutor.executeRawRequest(parameters, httpMethod: "DELETE", session: session, completion: completion)
    }
    
    private static func executeRawRequest<T: IChangeResponse>(_ parameters: IBasePostRequest, httpMethod: String, session: URLSession, completion: @escaping (Result<T?, SSCError>) -> ())
    {
        guard var request: URLRequest = try? parameters.buildHTTPRequest() else
        {
            completion(.failure(.badRequest("can not build request: unknown")))
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = httpMethod
        request.httpBody = parameters.buildRequestBody()
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if (error != nil)
            {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else
            {
                completion(.failure(.networkErrorWithStatusCode("status code: \(String(describing: response?.httpStatusCode))")))
                return
            }

            let result = T(
                        data: data,
                        headers: (response as? HTTPURLResponse)?.allHeaderFields as? [String:String],
                        statusCode: response?.httpStatusCode ?? 0
            )
            
            completion(.success(result))
        }
        
        task.resume()
    }
    
}

extension URLResponse
{
    
    var httpStatusCode: Int?
    {
        if let httpResponse = self as? HTTPURLResponse
        {
            return httpResponse.statusCode
        }
        return nil
    }
}
