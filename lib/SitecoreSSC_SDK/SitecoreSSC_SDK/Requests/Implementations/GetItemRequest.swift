
import Foundation

public class GetByIdRequest: BaseGetItemRequest, IGetByIdRequest
{
    public let itemId: UUID

    public init(
        itemId: String,
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig,
        fields: [String]?,
        standardFields: Bool?
        )
    {
        guard let itemIdValue: UUID = UUID(uuidString: itemId) else
        {
            fatalError("itemId unknown format")
        }
        
        self.itemId = itemIdValue
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, standardFields: standardFields, fields: fields)
    }
    
    public init(
        itemId: UUID,
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        fields: [String]?,
        standardFields: Bool?
        )
    {
        self.itemId = itemId
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, standardFields: standardFields, fields: fields)
    }
    
    public override func buildUrlString(sessionConfig: ISessionConfig) -> String?
    {
        let url = sessionConfig.instanceUrl
            + sessionConfig.requestSyntax.ItemSSCEndpoint
            + sessionConfig.requestSyntax.ItemSSCItemsEndpoint
            + sessionConfig.requestSyntax.urlPathSeparator
            + self.itemId.uuidString
        
        return url
    }
}

public class GetByPathRequest: BaseGetItemRequest, IGetByPathRequest
{
    public let itemPath: String
    
    public init(
        itemPath: String,
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        fields: [String]?,
        standardFields: Bool?
        )
    {
        self.itemPath = itemPath
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, standardFields: standardFields, fields: fields)
    }

    public override func buildUrlString(sessionConfig: ISessionConfig) -> String?
    {
        let url = sessionConfig.instanceUrl
            + sessionConfig.requestSyntax.ItemSSCEndpoint
            + sessionConfig.requestSyntax.ItemSSCItemsEndpoint
        
        return url
    }
   
    public override func buildUrlParametersString(sessionConfig: ISessionConfig) -> String?
    {
        let baseParameters = super.buildUrlParametersString(sessionConfig: sessionConfig)
        
        let escapedPath: String = self.itemPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        var parameters = sessionConfig.requestSyntax.ItemPathParameterName
            + sessionConfig.requestSyntax.urlParmeterAssignSign
            + escapedPath
            
        if (baseParameters != nil)
        {
            parameters = parameters + sessionConfig.requestSyntax.urlParametersSeparator
                                    + baseParameters!
        }
        
        return parameters
    }
}

public class GetChildrenRequest: BaseGetItemRequest, IGetChildrenRequest
{
    public let parentId: UUID
    
    public init(
        parentId: UUID,
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        standardFields: Bool?,
        fields: [String]?,
        ignoreCache: Bool
        )
    {
        self.parentId = parentId
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, standardFields: standardFields, fields: fields, ignoreCache: ignoreCache)
    }
    
    public override func buildUrlString(sessionConfig: ISessionConfig) -> String?
    {
        let url = sessionConfig.instanceUrl
            + sessionConfig.requestSyntax.ItemSSCEndpoint
            + sessionConfig.requestSyntax.ItemSSCItemsEndpoint
            + sessionConfig.requestSyntax.urlPathSeparator
            + self.parentId.uuidString
            + sessionConfig.requestSyntax.urlPathSeparator
            + sessionConfig.requestSyntax.ItemSSCChildrenAction
        
        return url
    }
    
    
}

