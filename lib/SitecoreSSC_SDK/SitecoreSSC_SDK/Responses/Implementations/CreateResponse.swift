
import Foundation

public class CreateResponse: IChangeResponse
{
    let statusCode: Int
    public private(set) var createdItemId: UUID? = nil
    
    private let locationHeaderTitle = "Location"
    private let itemIdPrefixInPath = "ssc/item/" //@igk can be taken from the ISscUrlParameters???
    private let udidLenght = 36
    
    public required init(data: Data, headers: [String:String]?, statusCode: Int)
    {
        self.statusCode = statusCode
        
        if let itemIdString = self.extractItemIdFromPath(headers?[locationHeaderTitle])
        {
            self.createdItemId = UUID(uuidString: itemIdString)
        }
    }
    
    private func extractItemIdFromPath(_ itemPath: String?) -> String?
    {
        if let itemPath = itemPath,
           let idStartingIndexRange = itemPath.range(of: itemIdPrefixInPath)
        {
            let range = idStartingIndexRange.upperBound..<itemPath.index(idStartingIndexRange.upperBound, offsetBy: udidLenght)

            let id = itemPath[range]
            
            return String(id)
        }
        
        return nil
    }
    
    public func isSuccessful() -> Bool
    {
        return statusCode == 201 && self.createdItemId != nil
    }
    
}
