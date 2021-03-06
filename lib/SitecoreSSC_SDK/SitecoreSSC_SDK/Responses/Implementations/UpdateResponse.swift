import Foundation

public class UpdateResponse: IChangeResponse {
    
    let statusCode: Int
    
    public required init(data: Data, headers: [String:String]?, statusCode: Int) {
        self.statusCode = statusCode
    }
    
    public func isSuccessful() -> Bool {
        return statusCode == 204
    }
    
}
