
import Foundation


public class CreateItemRequestBuilder: BaseChangeItemRequestBuilder<CreateItemRequest>
{
    static let ItemNameFieldName = "ItemName"
    static let TemplateIdFieldName = "TemplateID"
    
    var itemPath: String
    
    required init(_ itemPath: String)
    {
        self.itemPath = itemPath
    }
    
    public func ItemName(_ value: String) -> Self
    {
        _ = self.addFieldsToChange(value, forKey: CreateItemRequestBuilder.ItemNameFieldName)
        
        return self
    }
    
    public func TemplateId(_ value: String) -> Self
    {
        _ = self.addFieldsToChange(value, forKey: CreateItemRequestBuilder.TemplateIdFieldName)
        
        return self
    }
    
    public func TemplateId(_ value: UUID) -> Self
    {
        _ = self.TemplateId(value.uuidString)
        
        return self
    }
    
    
    override public func build() -> CreateItemRequest
    {
        let itemSource = ItemSource(database: self.database, language: self.language, versionNumber: self.versionNumber)
        
        let request = CreateItemRequest(
            parentPath: self.itemPath,
            fieldsToCreateList: self.fieldsToChangeList,
            itemSource: itemSource,
            sessionConfig: self.sessionConfig
        )
        
        return request
    }
    
    
    //Compatibility
    
    public override func addFieldsToChange(_ value: String, forKey key: String) -> Self
    {
        _ = super.addFieldsToChange(value, forKey: key)
        return self
    }
    
    public override func addFieldsToChange(_ value: [String: String]) -> Self
    {
        _ = super.addFieldsToChange(value)
        return self
    }
    
    public override func database(_ value: String) -> Self
    {
        _ = super.database(value)
        return self
    }
    
    public override func language(_ value: String) -> Self
    {
        _ = super.language(value)
        return self
    }
    
    public override func versionNumber(_ value: NSNumber) -> Self
    {
        _ = super.versionNumber(value)
        return self
    }
}
