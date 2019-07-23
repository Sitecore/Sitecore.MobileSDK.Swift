
import Foundation

public class ReadItemByIdRequestBuilder: BaseReadRequestBuilder<GetByIdRequest>
{
    var itemId: UUID
    
    required init(_ itemId: UUID)
    {
        self.itemId = itemId
    }
    
    init(_ itemId: String)
    {
        guard let value: UUID = UUID(uuidString: itemId) else
        {
            fatalError("itemId unknown format")
        }
    
        self.itemId = value
    }
    
    override public func build() -> GetByIdRequest
    {
        let itemSource = ItemSource(database: self.database, language: self.language, versionNumber: self.versionNumber)
        
        let request = GetByIdRequest(itemId: self.itemId,
                                     itemSource: itemSource,
                                     sessionConfig: self.sessionConfig,
                                     fields: self.fields,
                                     standardFields: self.includeStandardTemplateFields)
        
        return request
    }
}
