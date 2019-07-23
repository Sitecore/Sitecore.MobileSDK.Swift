
import Foundation

class SearchResponseJsonParser : IResponseParser
{
    func parseData(data: Data, sessionConfig: ISessionConfig?, source: IItemSource?) -> [ISitecoreItem]
    {
        var items: [ISitecoreItem] = [] //@igk, is this ok!?
        
        do
        {
            let rawResult: [String: Any] = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            if let result = rawResult["Results"] as? Array<[String: Any]>
            {
                items = result.map({ (elem) -> ISitecoreItem in
                    
                    return SCItem(fields: elem, sessionConfig: sessionConfig, source: source)
                })
                
//                self.totalItemsCount = (rawResult as! [String: Any])["TotalCount"] as! Int
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        return items
    }
    
    
}
