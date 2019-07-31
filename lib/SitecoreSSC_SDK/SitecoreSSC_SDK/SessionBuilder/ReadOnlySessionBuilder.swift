
import Foundation

class ReadOnlySessionBuilder: BaseSessionBuilder, IReadOnlySessionBuilder
{
    public override init(_ url: String)
    {
        super.init(url)
    }
    
    public func build() -> ISSCReadOnlySession
    {
        return SSCSession(url: urlString,
                          urlSession: customUrlSession,
                          autologinCredentials: credentials)
    }
    
}

public protocol IReadOnlySessionBuilder: IBaseSessionBuilder
{
    func build() -> ISSCReadOnlySession
}
