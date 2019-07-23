
import Foundation

class ItemsResponse: IItemsResponse
{
    public internal(set) var itemsPerPage: Int = 0
    public internal(set) var currentPage: Int = 0
    
    internal var statusCode: Int = 0
    
    var items: [ISitecoreItem]
    
    required init(items: [ISitecoreItem], statusCode: Int, pagingParameters: IPagingParameters?)
    {
        self.items = items
        self.statusCode = statusCode
        
        self.itemsPerPage = pagingParameters?.itemsPerPageCount ?? 0
        self.currentPage = pagingParameters?.pageNumber ?? 0
    }
    
    public func isSuccessful() -> Bool
    {
        return self.statusCode > 199 && self.statusCode < 300 //@igk refactor this
    }
    
    public var totalItemsCount: Int
    {
        get
        {
            return self.items.count
        }
    }
}
