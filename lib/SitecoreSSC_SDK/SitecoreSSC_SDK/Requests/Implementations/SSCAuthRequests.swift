
import Foundation

public protocol ILoginRequest: IBasePostRequest
{
    var credentials: ISCCredentials { get }
}

public protocol ILogoutRequest: IBasePostRequest
{
    
}

public class LoginRequest: ILoginRequest
{
    public let credentials: ISCCredentials
    public let sessionConfig: ISessionConfig?

    internal init(credentils: ISCCredentials, sessionConfig: ISessionConfig?)
    {
        self.credentials = credentils
        self.sessionConfig = sessionConfig
    }
    
    public func buildUrlParametersString(sessionConfig: ISessionConfig) -> String?
    {
        return nil
    }
    
    public func buildRequestBody() -> Data?
    {
        let domain: String = self.credentials.domain ?? CredentialsDefaults.defaultDomain
        
        let body = "{\"domain\":\"\(domain)\",\"username\":\"\(self.credentials.username)\",\"password\":\"\(self.credentials.password)\"}"
                
        return body.data(using: .utf8)!
    }

    public func buildHTTPRequest() throws -> URLRequest
    {
        guard let urlString = self.buildUrlString(sessionConfig: self.sessionConfig!),
              let url       = URL(string: urlString)
        else
        {
            throw SSCError.runtimeError(ErrorDescriptions.canNotBuilUrlFor("AUTH request"))
        }
        
        return URLRequest(url: url)
    }
    
    public func buildUrlString(sessionConfig: ISessionConfig) -> String?
    {
        let url = sessionConfig.instanceUrl
            + sessionConfig.requestSyntax.ItemSSCEndpoint
            + sessionConfig.requestSyntax.ItemSSCAuthEndpoint
            + sessionConfig.requestSyntax.ItemSSCLoginAction
        
        return url
    }
    
}

class LogoutRequest: ILogoutRequest
{
    var sessionConfig: ISessionConfig?
    
    init(sessionConfig: ISessionConfig)
    {
        self.sessionConfig = sessionConfig
    }
    
    func buildRequestBody() -> Data?
    {
        return Data()
    }
    
    func buildHTTPRequest() throws -> URLRequest
    {
        guard let urlString = self.buildUrlString(sessionConfig: self.sessionConfig!),
              let url = URL(string: urlString)
            else
            {
                throw SSCError.runtimeError(ErrorDescriptions.canNotBuilUrlFor("LOGOUT request"))
            }
        
        return URLRequest(url: url)
    }
    
    func buildUrlString(sessionConfig: ISessionConfig) -> String?
    {
        let url = sessionConfig.instanceUrl
            + sessionConfig.requestSyntax.ItemSSCEndpoint
            + sessionConfig.requestSyntax.ItemSSCAuthEndpoint
            + sessionConfig.requestSyntax.ItemSSCLogoutAction
        
        return url
    }
    
    func buildUrlParametersString(sessionConfig: ISessionConfig) -> String?
    {
        return nil
    }
    
    
}
