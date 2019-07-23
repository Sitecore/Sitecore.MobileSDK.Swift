
import Foundation

class RequestMerger
{
    
    let sessionConfig: ISessionConfig
    
    public init(sessionConfig: ISessionConfig)
    {
        self.sessionConfig = sessionConfig
    }
    
    public func mergePostRequest(_ request: IChangeRequest) -> IChangeRequest
    {
        var result: IChangeRequest
        
        switch request {
        case is CreateItemRequest:
            result = self.mergePostRequest(request as! ICreateRequest)
        case is EditItemRequest:
            result = self.mergePostRequest(request as! IEditRequest)
        default:
            print("Type not found request not merged")
            result = request
        }
        
        return result
    }
    
    public func mergePostRequest(_ request: ICreateRequest) -> CreateItemRequest
    {
        let autocompletedRequest = CreateItemRequest(
            parentPath: request.itemPath,
            fieldsToCreateList: request.fieldsToChangeList,
            itemSource: request.itemSource,
            sessionConfig: request.sessionConfig ?? self.sessionConfig
        )
                
        return autocompletedRequest
    }
    
    public func mergePostRequest(_ request: IEditRequest) -> EditItemRequest
    {
        let autocompletedRequest = EditItemRequest(
            itemId: request.itemId,
            fieldsToChangeList: request.fieldsToChangeList,
            itemSource: request.itemSource,
            sessionConfig: request.sessionConfig ?? self.sessionConfig
        )
        
        return autocompletedRequest
    }
    
    public func mergeGetRequest(_ request: IGetImageRequest) -> GetImageRequest
    {
        let autocompletedRequest = GetImageRequest(mediaItem: request.mediaItem,
                                                   sessionConfig: request.sessionConfig ?? self.sessionConfig,
                                                   ignoreCache: false,
                                                   mediaUrlFieldTitle: SCItemDefaults.ItemMedialUrlFieldTitle
        )
        
        return autocompletedRequest
    }
    
    
    public func mergeGetRequest(_ request: IBaseGetItemsRequest) -> IBaseGetItemsRequest
    {
        var result: IBaseGetItemsRequest
        
        switch request {
        case is DeleteItemRequest:
            result = self.mergeGetRequest(request as! IDeleteItemRequest)
        case is GetByIdRequest:
            result = self.mergeGetRequest(request as! IGetByIdRequest)
        case is GetChildrenRequest:
            result = self.mergeGetRequest(request as! IGetChildrenRequest)
        case is GetByPathRequest:
            result = self.mergeGetRequest(request as! IGetByPathRequest)
        case is StoredQueryRequest:
            result = self.mergeGetRequest(request as! IStoredSitecoreSearchRequest)
        default:
            print("Type not found request not merged")
            result = request
        }
        
        return result
    }
    
    public func mergeGetRequest(_ request: IDeleteItemRequest) -> DeleteItemRequest
    {
        let autocompletedRequest = DeleteItemRequest(
            itemId: request.itemId,
            itemSource: request.itemSource,
            sessionConfig: request.sessionConfig ?? self.sessionConfig
        )
                
        return autocompletedRequest
    }
    
    public func mergeGetRequest(_ request: IGetChildrenRequest) -> GetChildrenRequest
    {
        let autocompletedRequest = GetChildrenRequest(
            parentId: request.parentId,
            itemSource: request.itemSource,
            sessionConfig: request.sessionConfig ?? self.sessionConfig,
            standardFields: request.includeStandardTemplateFields,
            fields: request.fields,
            ignoreCache: request.ignoreCache
        )
        
        autocompletedRequest.fields = request.fields
        
        return autocompletedRequest
    }
    
    public func mergeGetRequest(_ request: IGetByPathRequest) -> GetByPathRequest
    {
        let autocompletedRequest = GetByPathRequest(
            itemPath: request.itemPath,
            itemSource: request.itemSource,
            sessionConfig: request.sessionConfig ?? self.sessionConfig,
            fields: request.fields,
            standardFields: request.includeStandardTemplateFields
        )
        
        autocompletedRequest.fields = request.fields
        
        return autocompletedRequest
    }
    
    public func mergeGetRequest(_ request: IGetByIdRequest) -> GetByIdRequest
    {
        let autocompletedRequest = GetByIdRequest(
            itemId: request.itemId.uuidString,
            itemSource: request.itemSource,
            sessionConfig: request.sessionConfig ?? self.sessionConfig,
            fields: request.fields,
            standardFields: request.includeStandardTemplateFields
        )
        
        autocompletedRequest.fields = request.fields
        
        return autocompletedRequest
    }

    public func mergeGetRequest(_ request: IStoredSitecoreSearchRequest) -> StoredQueryRequest
    {
        let autocompletedRequest = StoredQueryRequest(
            itemId: request.itemId,
            pagingParameters: request.pagingParameters,
            itemSource: request.itemSource,
            sessionConfig: request.sessionConfig ?? self.sessionConfig,
            fields: request.fields,
            standardFields: request.includeStandardTemplateFields
        )
        
        autocompletedRequest.fields = request.fields
        
        return autocompletedRequest
    }
    
}
