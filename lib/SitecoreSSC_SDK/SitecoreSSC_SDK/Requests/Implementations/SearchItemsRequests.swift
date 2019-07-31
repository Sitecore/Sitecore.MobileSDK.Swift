
import Foundation


public class StoredQueryRequest: BasePaggedGetItemRequest, IStoredSitecoreSearchRequest
{
    public var itemId: UUID
    
    #warning ("@igk add 'ignoreCache config'!!!")
    public init(
        itemId: UUID,
        pagingParameters: IPagingParameters?,
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        fields: [String]?,
        standardFields: Bool
        )
    {
        self.itemId = itemId
        super.init(pagingParameters: pagingParameters,
                   itemSource:       itemSource,
                   sessionConfig:    sessionConfig,
                   fields:           fields,
                   standardFields:   standardFields
                   )
    }
    
    public override func buildUrlString(sessionConfig: ISessionConfig) -> String?
    {
        let url = sessionConfig.instanceUrl
            + sessionConfig.requestSyntax.ItemSSCEndpoint
            + sessionConfig.requestSyntax.ItemSSCItemsEndpoint
            + sessionConfig.requestSyntax.urlPathSeparator
            + self.itemId.uuidString
            + sessionConfig.requestSyntax.SitecoreQueryParameterName
        
        return url
    }

}
 
