
import Foundation

public class PagingParameters: NSObject, IPagingParameters
{
    public var itemsPerPageCount: Int
    public var pageNumber: Int
    
    public init(itemsPerPage: Int, pageNumber: Int)
    {
        self.itemsPerPageCount = itemsPerPage
        self.pageNumber = pageNumber
    }
}

@objc public protocol IPagingParameters: class
{
    var itemsPerPageCount: Int { get }
    var pageNumber: Int { get }
}
