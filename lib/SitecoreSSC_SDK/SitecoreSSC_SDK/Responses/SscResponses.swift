
import Foundation

public protocol IBaseGetResponse: IBaseResponse
{
    init(items: [ISitecoreItem], statusCode: Int, pagingParameters: IPagingParameters?)
}

public protocol IBaseResponse
{
    func isSuccessful() -> Bool
}

public protocol IAuthResponse: IChangeResponse
{

}

public protocol IItemsResponse: IBaseGetResponse
{
    var totalItemsCount: Int {get}
    var itemsPerPage:    Int {get}
    var currentPage:     Int {get}
    
    var items: [ISitecoreItem] { get }
}

public protocol IChangeResponse: IBaseResponse
{
    init(data: Data, headers: [String:String]?, statusCode: Int)
}

