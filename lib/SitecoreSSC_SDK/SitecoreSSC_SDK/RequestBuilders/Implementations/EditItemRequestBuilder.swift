
import Foundation

public class EditItemRequestBuilder: BaseChangeItemRequestBuilder<EditItemRequest>
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
    
    override public func build() -> EditItemRequest
    {
        let itemSource = ItemSource(database: self.database, language: self.language, versionNumber: self.versionNumber)
        
        let request = EditItemRequest(
            itemId: self.itemId,
            fieldsToChangeList: self.fieldsToChangeList,
            itemSource: itemSource,
            sessionConfig: self.sessionConfig
        )
        
        return request
    }
    
}
