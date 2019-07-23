
import Foundation

class GetImageRequest: IGetImageRequest
{
    public let mediaItem: ISitecoreItem
    public let ignoreCache: Bool
    public let sessionConfig: ISessionConfig?
    private let mediaUrlFieldTitle: String
    
    public init(
        mediaItem: ISitecoreItem,
        sessionConfig: ISessionConfig?,
        ignoreCache: Bool = false,
        mediaUrlFieldTitle: String = SCItemDefaults.ItemMedialUrlFieldTitle
        )
    {
        self.mediaItem = mediaItem
        self.sessionConfig = sessionConfig
        self.ignoreCache = ignoreCache
        self.mediaUrlFieldTitle = mediaUrlFieldTitle
    }
    
    public func buildUrlParametersString(sessionConfig: ISessionConfig) -> String? {
        return nil
    }
    
    public func buildUrlString(sessionConfig: ISessionConfig) -> String?
    {
        let url = sessionConfig.instanceUrl
        
        let imagePath = self.mediaItem.fields[self.mediaUrlFieldTitle]! as! String
        
        return "\(url)/\(imagePath)"
    }
}
