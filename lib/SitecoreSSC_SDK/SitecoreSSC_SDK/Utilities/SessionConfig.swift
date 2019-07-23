
import Foundation

@objc public protocol ISessionConfig
{
    var instanceUrl: String { get }
    var requestSyntax: ISSCUrlParameters { get } //TODO: @igk make it private
}

public class SessionConfig: ISessionConfig
{
    public let instanceUrl: String
    public let requestSyntax: ISSCUrlParameters
    
    init (url: String, requestSyntax: ISSCUrlParameters)
    {
        self.instanceUrl = url
        self.requestSyntax = requestSyntax
    }
    
}
