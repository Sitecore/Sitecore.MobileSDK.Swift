
import Foundation

public  class ScRequestBuilder
{
    //MARK: -
    //MARK: GET ITEM
    
    public static func getItemByIdRequest(_ itemId: String) -> ReadItemByIdRequestBuilder
    {
        return ReadItemByIdRequestBuilder(itemId)
    }
    
    public static func getItemByIdRequest(_ itemId: UUID) -> ReadItemByIdRequestBuilder
    {
        return ReadItemByIdRequestBuilder(itemId)
    }
    
    public static func getItemByPathRequest(_ itemPath: String) -> ReadItemByPathRequestBuilder
    {
        return ReadItemByPathRequestBuilder(itemPath)
    }
    
    //MARK: -
    //MARK: GET CHILDREN
    
    public static func getChildrenByParentIdRequest(_ itemId: String) -> ReadChildrenRequestBuilder
    {
        return ReadChildrenRequestBuilder(itemId)
    }
    
    public static func getChildrenByParentIdRequest(_ itemId: UUID) -> ReadChildrenRequestBuilder
    {
        return ReadChildrenRequestBuilder(itemId)
    }
    
    //MARK: -
    //MARK: SEARCH
    
    public static func runStoredSearchItemRequest(_ itemId: UUID) -> StoredSearchRequestBuilder
    {
        return StoredSearchRequestBuilder(itemId)
    }
    
    public static func runStoredSearchItemRequest(_ itemId: String) -> StoredSearchRequestBuilder
    {
        return StoredSearchRequestBuilder(itemId)
    }
    
    
    //MARK: -
    //MARK: CREATE
    public static func createItemByPathRequest(_ parentPath: String) -> CreateItemRequestBuilder
    {
        return CreateItemRequestBuilder(parentPath)
    }
    
    //MARK: -
    //MARK: UPDATE
    
    public static func updateItemRequest(_ itemId: String) -> EditItemRequestBuilder
    {
        return EditItemRequestBuilder(itemId)
    }
    
    public static func updateItemRequest(_ itemId: UUID) -> EditItemRequestBuilder
    {
        return EditItemRequestBuilder(itemId)
    }
    
    //MARK: -
    //MARK: DELETE
    
    public static func deleteItemRequest(_ itemId: String) -> DeleteItemRequestBuilder
    {
        return DeleteItemRequestBuilder(itemId)
    }
    
    public static func deleteItemRequest(_ itemId: UUID) -> DeleteItemRequestBuilder
    {
        return DeleteItemRequestBuilder(itemId)
    }
    
    //MARK: -
    //MARK: MEDIA
    
    public static func downloadImageRequestFor(mediaItem: ISitecoreItem) -> DownloadImageRequestBuilder
    {
        return DownloadImageRequestBuilder(mediaItem)
    }
}
