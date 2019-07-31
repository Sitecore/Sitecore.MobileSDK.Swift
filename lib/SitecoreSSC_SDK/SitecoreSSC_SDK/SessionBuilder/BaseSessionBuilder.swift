
import Foundation

class BaseSessionBuilder: IBaseSessionBuilder
{
    internal let urlString: String
    internal var customUrlSession: URLSession?
    internal var credentials: ISCCredentials?
    
    public init(_ url: String)
    {
        urlString = url
    }
    
    public func customUrlSession(_ session: URLSession) -> Self
    {
        self.customUrlSession = session
        
        return self
    }
    
    public func credentials(_ credentials: ISCCredentials) -> Self
    {
        self.credentials = credentials
        
        return self
    }
}

public protocol IBaseSessionBuilder
{
    func customUrlSession(_ session: URLSession) -> Self
    func credentials(_ credentials: ISCCredentials) -> Self
}
