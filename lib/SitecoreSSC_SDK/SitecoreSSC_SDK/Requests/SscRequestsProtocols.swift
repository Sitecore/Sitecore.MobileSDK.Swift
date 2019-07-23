
import Foundation

@objc public protocol IDeleteItemRequest: IGetByIdRequest, IBasePostRequest
{
    
}

@objc public protocol ICreateRequest: IGetByPathRequest, IChangeRequest
{

}

@objc public protocol IEditRequest: IGetByIdRequest, IChangeRequest
{

}

@objc public protocol IChangeRequest: IBasePostRequest
{
    var fieldsToChangeList: [String: String] { get }
}

@objc public protocol IOdataRequest: IBaseGetItemsRequest
{
    var odataQuery: String { get }
}

@objc public protocol IGetByIdRequest: IBaseGetItemsRequest
{
    var itemId: UUID { get }
}

@objc public protocol IGetByPathRequest: IBaseGetItemsRequest
{
    var itemPath: String { get }
}

@objc public protocol IGetChildrenRequest: IBaseGetItemsRequest
{
    var parentId: UUID { get }
}

@objc public protocol ISitecoreSearchRequest: IBaseGetPaginatedItemsRequest
{
    
}

@objc public protocol IStoredSitecoreSearchRequest: IBaseGetPaginatedItemsRequest
{
    var itemId: UUID { get }
}

@objc public protocol IBaseGetPaginatedItemsRequest: IBaseGetItemsRequest
{
    var pagingParameters: IPagingParameters? { get }
}

@objc public protocol IBaseGetItemsRequest: IBaseRequest
{
    var itemSource: IItemSource? { get }
    var includeStandardTemplateFields: Bool { get }
    var fields: [String] { get }
    
    var ignoreCache: Bool { get }
}

@objc public protocol IBasePostRequest: IBaseRequest
{
    func buildRequestBody() -> Data?
}

@objc public protocol IBaseRequest: IScRequest
{
    #warning ("@igk separate request builder required!")
    func buildHTTPRequest() throws -> URLRequest
}

@objc public protocol IGetImageRequest: IScRequest
{
    var mediaItem: ISitecoreItem { get }
}

@objc public protocol IScRequest
{
    var sessionConfig: ISessionConfig? { get }
    
    func buildUrlString(sessionConfig: ISessionConfig) -> String?
    func buildUrlParametersString(sessionConfig: ISessionConfig) -> String?
}

