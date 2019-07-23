
import Foundation

public enum SSCError: Error
{
    case badURL
    case badCredentials
    case badRequest(String)
    case unknownNetworkError(Error?)
    case networkError(Error?)
    case networkErrorWithStatusCode(String?)
    
    case runtimeError(String)
    case requesBuilderError(Error)
    case responseError(Error)
    
    case dataError(String?)
}

public class ErrorDescriptions
{
    static func canNotBuilUrlFor(_ request: String) -> String
    {
       return "Can not build url for \(request) request"
    }
    
    static func unknownNetworkError(userInfo: String) -> String
    {
        return "Unknown network error, user info: \(userInfo)"
    }
    
    static func requesBuilderError(userInfo: String) -> String
    {
        return "Can not build request, user info: \(userInfo)"
    }
}
