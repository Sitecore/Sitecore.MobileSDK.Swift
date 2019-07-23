
import Foundation
import SitecoreSSC_SDK

public class SIBAllChildrenRequestBuilder: NSObject, SCItemsLevelRequestBuilder
{
    public override init()
    {
        
    }
    
    public func itemsBrowser(_ sender: Any, levelDownRequestFor item: ISitecoreItem, ignoreCache: Bool) -> IBaseGetItemsRequest
    {
        let requestBuilder = ScRequestBuilder.getChildrenByParentIdRequest(item.id)
                                .includeStandardTemplateFields(true)
                                .ignoreCache(ignoreCache)
        
        if let source = item.source
        {
            if let lang = source.language
                { _ = requestBuilder.language(lang) }
            if let db = source.database
                { _ = requestBuilder.database(db) }
            if let version = source.versionNumber
                { _ = requestBuilder.versionNumber(version) }
        }
            
        let request = requestBuilder.build()

        return request
    }

}
