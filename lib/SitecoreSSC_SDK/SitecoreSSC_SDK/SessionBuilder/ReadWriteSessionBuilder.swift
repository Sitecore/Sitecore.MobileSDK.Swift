
import Foundation

class ReadWriteSessionBuilder: BaseSessionBuilder, IReadWriteSessionBuilder
{
    public override init(_ url: String)
    {
        super.init(url)
    }
    
    public func build() -> ISSCReadWriteSession
    {
        return SSCSession(url: urlString,
                          urlSession: customUrlSession,
                          autologinCredentials: credentials)
    }
    
}


public protocol IReadWriteSessionBuilder: IBaseSessionBuilder
{
    func build() -> ISSCReadWriteSession
}
