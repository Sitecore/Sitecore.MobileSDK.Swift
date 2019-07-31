
import Foundation

public protocol ISCCredentials
{
    var username: String { get }
    var password: String { get }
    var domain: String? { get }
}

public class SCCredentials: ISCCredentials
{

    public init (username: String, password: String, domain: String?)
    {
        self.username = username
        self.password = password
        self.domain = domain
    }
    
    public let username: String
    public let password: String
    public let domain: String?

}
