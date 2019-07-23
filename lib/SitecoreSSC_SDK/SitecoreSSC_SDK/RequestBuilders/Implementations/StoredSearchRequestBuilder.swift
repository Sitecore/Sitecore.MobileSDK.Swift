
import Foundation

public class StoredSearchRequestBuilder: BasePaggedRequestBuilder<StoredQueryRequest>
{
    internal let searchItemId: UUID
    
    public required init(_ searchItemId: UUID)
    {
        self.searchItemId = searchItemId
    }
    
    public init(_ searchItemId: String)
    {
        guard let value: UUID = UUID(uuidString: searchItemId) else
        {
            fatalError("itemId unknown format")
        }
        
        self.searchItemId = value
    }
    
    public override func build() -> StoredQueryRequest
    {
        #warning("@igk check for all parameters was set correctly!!!!")
        
        let itemSource = ItemSource(database: self.database, language: self.language, versionNumber: self.versionNumber)
        var pagingParams: PagingParameters? = nil
        
        if
        let itemsPerPageCount = self.itemsPerPageCount,
        let pageNumber = self.pageNumber
        {
            pagingParams = PagingParameters(itemsPerPage: itemsPerPageCount, pageNumber: pageNumber)
        }
        
        let standardFields: Bool = self.includeStandardTemplateFields ?? false
        
        let request = StoredQueryRequest(
            itemId: self.searchItemId,
            pagingParameters: pagingParams,
            itemSource: itemSource,
            sessionConfig: self.sessionConfig,
            fields: self.fields,
            standardFields: standardFields
        )

        return request
    }
    
}
