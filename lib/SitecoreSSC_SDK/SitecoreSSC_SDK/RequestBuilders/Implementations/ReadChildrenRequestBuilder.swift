
import Foundation

public class ReadChildrenRequestBuilder: BaseReadRequestBuilder<GetChildrenRequest>
{
    internal var parentId: UUID
    
    public required init(_ parentId: UUID)
    {
        self.parentId = parentId
    }
    
    public init(_ parentId: String)
    {
        guard let value: UUID = UUID(uuidString: parentId) else
        {
            fatalError("itemId unknown format")
        }
        
        self.parentId = value
    }
    
    public override func build() -> GetChildrenRequest
    {
        #warning("@igk check for all parameters set correctly!!!!")
        
        let itemSource = ItemSource(database: self.database, language: self.language, versionNumber: self.versionNumber)
        
        let request = GetChildrenRequest(parentId: self.parentId,
                                         itemSource: itemSource,
                                         sessionConfig: self.sessionConfig,
                                         standardFields: self.includeStandardTemplateFields,
                                         fields: self.fields,
                                         ignoreCache: false)
        return request
    }
}
