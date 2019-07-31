
import Foundation

public class SSCSession : NSObject, URLSessionDelegate, ISSCReadWriteSession
{
    private let sessionConfig:  ISessionConfig
    private let requestSyntax:  ISSCUrlParameters = ItemSSCV1UrlParameters()
    private let urlSession:     URLSession
    private let requestMerger:  RequestMerger
    private let odataApiKey:    UUID! = nil
    
    private var activeUser: String? = nil
    private var domain: String = CredentialsDefaults.defaultDomain
    
    private let credentialsStorage = CredentialsStorage()
    
    public init(url: String, urlSession: URLSession?)
    {
        self.sessionConfig = SessionConfig(url: url, requestSyntax: requestSyntax)
        
        if (urlSession == nil)
        {
            self.urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        }
        else
        {
            self.urlSession = urlSession!
        }
        
        self.urlSession.configuration.requestCachePolicy = .returnCacheDataElseLoad
        self.requestMerger = RequestMerger(sessionConfig: self.sessionConfig)
    }
    
    public convenience init(url: String, urlSession: URLSession?, autologinCredentials: ISCCredentials?)
    {
        self.init(url: url, urlSession: urlSession)
        if let credentials = autologinCredentials
        {
            self.enableAutologinWithCredentials(credentials)
        }
    }
    
    public convenience init(url: String, autologinCredentials: ISCCredentials)
    {
        self.init(url: url, urlSession: nil, autologinCredentials: autologinCredentials)
    }
    
    public convenience init(url: String)
    {
        self.init(url: url, urlSession: nil)
    }

}

extension SSCSession: ISSCAuthSession
{
    private func sendAuthRequest(_ request: IBasePostRequest, completion:@escaping (Result<AuthResponse?, SSCError>) -> ())
    {
        RequestExecutor.executeAuthRequest(request, session: self.urlSession, completion: completion)
    }
    
    public func sendLoginRequest(_ request: ILoginRequest, completion: @escaping (Result<AuthResponse?, SSCError>) -> ())
    {
        let autocompletedRequest = LoginRequest(credentils: request.credentials, sessionConfig: self.sessionConfig)

        self.sendAuthRequest(autocompletedRequest, completion: completion)
    }
    
    public func sendLogoutRequest(completion:@escaping (Result<AuthResponse?, SSCError>) -> ())
    {
        let logoutRequest = LogoutRequest(sessionConfig: self.sessionConfig)
        
        self.sendAuthRequest(logoutRequest, completion: completion)
    }
    
    public func enableAutologinWithCredentials(_ credentials: ISCCredentials)
    {
        self.activeUser = credentials.username
        self.credentialsStorage.removePassword(for: self.activeUser!)
        self.credentialsStorage.setPassword(credentials.password, for: self.activeUser!)
        
        if (credentials.domain != nil)
        {
            self.domain = credentials.domain!
        }
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
    
    func autologin(completion: @escaping (SSCError?)->())
    {
        if (self.IsUserLoggedIn)
        {
            completion(nil)
            return
        }
        
        if (IsAutologinActive)
        {
            let password = self.credentialsStorage.getPassword(for: self.activeUser!)
            let credentials = SCCredentials(username: self.activeUser!, password: password!, domain: self.domain)
            
            let loginRequest = LoginRequest(credentils: credentials, sessionConfig: self.sessionConfig)
            
            self.sendLoginRequest(loginRequest) { result in
                
                switch result
                {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
        else
        {
            completion(nil) //anonymous
        }
    }

    var IsAutologinActive: Bool
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
    
    var IsUserLoggedIn: Bool
    {
        get
        {
            if let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: self.sessionConfig.instanceUrl)!)
            {
                return CredentialsDefaults.authCoockieIsNotExpired(cookies: cookies)
            }
            
            return false
        }
    }
    
}

extension SSCSession: ISSCReadOnlySession
{
    public func downloadImageForItem(_ item: ISitecoreItem, completion: DataDownloadingProcess)
    {
        let imageRequest = GetImageRequest(mediaItem: item, sessionConfig: self.sessionConfig)

        ScImageLoader.getImageWithRequest(imageRequest, session: self.urlSession, completion: completion)
    }
    
    @discardableResult

    public func sendDownloadImageRequest(_ request: IGetImageRequest, completion: DataDownloadingProcess) -> RequestToken?
    {
        let autocompletedRequest = self.requestMerger.mergeGetRequest(request)

        return ScImageLoader.getImageWithRequest(autocompletedRequest, session: self.urlSession, completion: completion)
    }
    
    public func sendGetItemsRequest(_ request: IBaseGetItemsRequest, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        switch request
        {
            case is GetByIdRequest:
                self.sendGetSingleItemRequest(request, completion: completion)
            case is GetByPathRequest:
                self.sendGetSingleItemRequest(request, completion: completion)
            case is GetChildrenRequest:
                self.sendGetMultipleItemsRequest(request, completion: completion)
            case is StoredQueryRequest:
                self.sendGetMultipleItemsRequest(request, completion: completion)
            default:
                print("Type not found request not merged")
                completion(.failure(.badRequest("can not build request: unknown request type")))
        }
    }
    
    public func sendGetItemByPathRequest(_ request: IGetByPathRequest, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        self.sendGetSingleItemRequest(request, completion: completion)
    }
    
    public func sendGetItemByIdRequest(_ request: IGetByIdRequest, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        self.sendGetSingleItemRequest(request, completion: completion)
    }
    
    public func sendGetChildrenRequest(_ request: IGetChildrenRequest, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        self.sendGetMultipleItemsRequest(request, completion: completion)
    }
    
    public func sendSerchItemsRequest(_ request: IStoredSitecoreSearchRequest, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        let responseParser = SearchResponseJsonParser()
        
        self.executeItemsRequest(request, parser: responseParser, completion: completion)
    }
    
    internal func sendGetSingleItemRequest(_ request: IBaseGetItemsRequest, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        let responseParser = SingleItemResponseParser()
        
        self.executeItemsRequest(request, parser: responseParser, completion: completion)
    }
    
    internal func sendGetMultipleItemsRequest(_ request: IBaseGetItemsRequest, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        let responseParser = ItemsListResponseJsonParser()
                
        self.executeItemsRequest(request, parser: responseParser, completion: completion)
    }
    
    internal func executeItemsRequest(_ request: IBaseGetItemsRequest, parser: IResponseParser, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        self.autologin(completion: { (error) in
            
            if (error != nil)
            {
                completion(.failure(error!))
            }
            
            let autocompletedRequest = self.requestMerger.mergeGetRequest(request)

            RequestExecutor.executeGetRequest(autocompletedRequest,
                                              parser:   parser,
                                              session:  self.urlSession,
                                              completion: completion)
        })
    }
}

extension SSCSession: ISSCWriteSession
{
    public func sendCreateItemRequest(_ request: ICreateRequest, completion: @escaping (Result<CreateResponse?, SSCError>) -> ())
    {
        self.autologin(completion: { (error) in
            
            if (error != nil)
            {
                completion(.failure(error!))
            }
            
            let autocompletedRequest = self.requestMerger.mergePostRequest(request)
            
            RequestExecutor.executeCreateRequest(autocompletedRequest, session: self.urlSession, completion: completion)
        })
    }
    
    public func sendUpdateItemRequest(_ request: IEditRequest, completion:@escaping (Result<UpdateResponse?, SSCError>) -> ())
    {
        self.autologin(completion: { (error) in
            
            if (error != nil)
            {
                completion(.failure(error!))
            }
            
            let autocompletedRequest = self.requestMerger.mergePostRequest(request)
            
            RequestExecutor.executePatchRequest(autocompletedRequest, session: self.urlSession, completion: completion)
        })
    }
    
    public func sendDeleteItemRequest(_ request: IDeleteItemRequest, completion:@escaping (Result<DeleteResponse?, SSCError>) -> ())
    {
         self.autologin(completion: { (error) in
            
            if (error != nil)
            {
                completion(.failure(error!))
            }
            
            let autocompletedRequest = self.requestMerger.mergeGetRequest(request)
            
            RequestExecutor.executeDeleteRequest(autocompletedRequest, session: self.urlSession, completion: completion)
        })
    }
}

#warning("@igk not implemented")
extension SSCSession: ISSCOdataSession
{
    fileprivate func SetOdataApiKey(_key: UUID)
    {
        doesNotRecognizeSelector(#function)
    }
    
    fileprivate func sendOdataRequest(_ request: IOdataRequest, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    {
        doesNotRecognizeSelector(#function)
    }
}

private protocol ISSCOdataSession
{
    func SetOdataApiKey(_key: UUID)
    func sendOdataRequest(_ request: IOdataRequest, completion:@escaping (Result<IItemsResponse?, SSCError>) -> ())
}

public protocol ISSCAuthSession
{
    func enableAutologinWithCredentials(_ credentials: ISCCredentials)
    func sendLoginRequest(_ request: ILoginRequest, completion: @escaping (Result<AuthResponse?, SSCError>) -> ())
    func sendLogoutRequest(completion: @escaping (Result<AuthResponse?, SSCError>) -> ())
}

public protocol ISSCReadOnlySession
{
    func sendGetItemsRequest(_ request: IBaseGetItemsRequest, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    func sendGetItemByPathRequest(_ request: IGetByPathRequest,         completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    func sendGetItemByIdRequest(_ request: IGetByIdRequest,             completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    func sendGetChildrenRequest(_ request: IGetChildrenRequest,         completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    func sendSerchItemsRequest(_ request: IStoredSitecoreSearchRequest, completion: @escaping (Result<IItemsResponse?, SSCError>) -> ())
    func downloadImageForItem(_ item: ISitecoreItem, completion: DataDownloadingProcess)
    func sendDownloadImageRequest(_ request: IGetImageRequest, completion: DataDownloadingProcess) -> RequestToken?
}

public protocol ISSCWriteSession
{
    func sendCreateItemRequest(_ request: ICreateRequest,     completion:@escaping (Result<CreateResponse?, SSCError>) -> ())
    func sendUpdateItemRequest(_ request: IEditRequest,       completion:@escaping (Result<UpdateResponse?, SSCError>) -> ())
    func sendDeleteItemRequest(_ request: IDeleteItemRequest, completion:@escaping (Result<DeleteResponse?, SSCError>) -> ())
}

public protocol ISSCReadWriteSession: ISSCReadOnlySession, ISSCWriteSession
{
    
}
