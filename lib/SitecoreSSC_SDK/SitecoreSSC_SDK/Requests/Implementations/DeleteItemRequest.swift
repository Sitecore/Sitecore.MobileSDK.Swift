
import Foundation

public class DeleteItemRequest: GetByIdRequest, IDeleteItemRequest
{
    public init(
        itemId: UUID,
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?
        )
    {
        super.init(
            itemId: itemId,
            itemSource: itemSource,
            sessionConfig: sessionConfig,
            fields: nil,
            standardFields: nil
        )
    }
    
    public func buildRequestBody() -> Data?
    {
        return "".data(using: .utf8)
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
    
    public override func buildUrlParametersString(sessionConfig: ISessionConfig) -> String?
    {
        return self.buildCommonParametersString(sessionConfig: sessionConfig)
    }
    
}
