
import Foundation

public class EditItemRequest: GetByIdRequest, IEditRequest
{
    public private(set) var fieldsToChangeList: [String : String]
    
    public init(
        itemId: UUID,
        fieldsToChangeList: [String : String],
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?
        )
    {
        self.fieldsToChangeList = fieldsToChangeList
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
        let jsonData =  try? JSONSerialization.data(withJSONObject: self.fieldsToChangeList, options: [])
        
        return jsonData
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
