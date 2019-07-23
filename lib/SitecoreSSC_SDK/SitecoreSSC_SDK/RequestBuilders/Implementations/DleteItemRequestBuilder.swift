
import Foundation

public class DeleteItemRequestBuilder: BaseRequestBuilder<DeleteItemRequest>
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
    
    override public func build() -> DeleteItemRequest
    {
        let itemSource = ItemSource(database: self.database, language: self.language, versionNumber: self.versionNumber)
        
        let request = DeleteItemRequest(
            itemId: self.itemId,
            itemSource: itemSource,
            sessionConfig: self.sessionConfig
        )
        
        return request
    }
    
}
