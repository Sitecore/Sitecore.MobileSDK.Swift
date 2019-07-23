
import Foundation

public class AuthResponse: IAuthResponse {

    let statusCode: Int
    
    required public init(data: Data, headers: [String:String]?, statusCode: Int) {
        self.statusCode = statusCode
    }
    
    public func isSuccessful() -> Bool {
        return statusCode == 200
    }
    
}
