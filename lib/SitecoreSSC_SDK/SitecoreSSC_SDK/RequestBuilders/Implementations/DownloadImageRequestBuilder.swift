
import Foundation

public class DownloadImageRequestBuilder: BaseRequestBuilder<IGetImageRequest>
{    
    private var mediaItem: ISitecoreItem
    
    required public init(_ mediaItem: ISitecoreItem)
    {
        self.mediaItem = mediaItem
    }
    
    override public func build() -> IGetImageRequest
    {
        if ((self.database != nil) || (self.language != nil) || (self.versionNumber != nil))
        {
            let db = self.database ?? mediaItem.source?.database
            let ln = self.language ?? mediaItem.source?.language
            let vr = self.versionNumber ?? mediaItem.source?.versionNumber
            
            let source = ItemSource(database: db, language: ln, versionNumber: vr)
            
            self.mediaItem = SCItem(fields: self.mediaItem.fields, sessionConfig: self.sessionConfig, source: source)
        }
        
        return GetImageRequest(
            mediaItem: self.mediaItem,
            sessionConfig: self.sessionConfig
        )
    }
}
