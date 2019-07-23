
import Foundation

public protocol IResponseParser
{
    func parseData(data: Data, sessionConfig: ISessionConfig?, source: IItemSource?) -> [ISitecoreItem]
}
