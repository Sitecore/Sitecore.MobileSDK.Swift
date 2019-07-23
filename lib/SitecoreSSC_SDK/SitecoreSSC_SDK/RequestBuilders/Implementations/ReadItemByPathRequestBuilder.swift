
import Foundation

public class ReadItemByPathRequestBuilder: BaseReadRequestBuilder<GetByPathRequest>
{
    var itemPath: String
    
    required init(_ itemPath: String)
    {
        self.itemPath = itemPath
    }
    
    override public func build() -> GetByPathRequest
    {
        let itemSource = ItemSource(database: self.database, language: self.language, versionNumber: self.versionNumber)

        let request = GetByPathRequest(itemPath: self.itemPath,
                                       itemSource: itemSource,
                                       sessionConfig: self.sessionConfig,
                                       fields: self.fields,
                                       standardFields: self.includeStandardTemplateFields)
        
        return request
    }
}
