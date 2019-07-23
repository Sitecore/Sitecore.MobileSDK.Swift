
import Foundation

public class CreateItemRequest: GetByPathRequest, ICreateRequest
{    
    public private(set) var fieldsToChangeList: [String : String]
    
    public init(
        parentPath: String,
        fieldsToCreateList: [String : String],
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?
        )
    {
        self.fieldsToChangeList = fieldsToCreateList
        super.init(itemPath: parentPath, itemSource: itemSource, sessionConfig: sessionConfig, fields: nil, standardFields: nil)
    }
    
    public func buildRequestBody() -> Data?
    {
        let jsonData = try? JSONSerialization.data(withJSONObject: self.fieldsToChangeList, options: [])

        return jsonData
    }
    
    public override func buildUrlString(sessionConfig: ISessionConfig) -> String?
    {
        let escapedPath: String = self.itemPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let url = sessionConfig.instanceUrl
            + sessionConfig.requestSyntax.ItemSSCEndpoint
            + sessionConfig.requestSyntax.ItemSSCItemsEndpoint
            + sessionConfig.requestSyntax.urlPathSeparator
            + escapedPath
        
        return url
    }
    
    public override func buildUrlParametersString(sessionConfig: ISessionConfig) -> String?
    {
        return self.buildCommonParametersString(sessionConfig: sessionConfig)
    }
    
}
