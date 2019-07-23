
import Foundation

public class CredentialsDefaults
{
    public static let defaultDomain: String = "Sitecore"
    
    public static func authCoockieIsNotExpired(cookies: [HTTPCookie]) -> Bool
    {
        let currentDate = Date()
        for cookie in cookies
        {
            let isAuthCookieExists: Bool = (".ASPXAUTH" == cookie.name) || (".AspNet.Cookies" == cookie.name)
            let cookieNotExpired: Bool = cookie.expiresDate! > currentDate
            
            if (isAuthCookieExists && cookieNotExpired)
            {
                return true
            }
        }
        
        return false
    }
}
