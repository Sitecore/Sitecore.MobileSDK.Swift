
import Foundation

class ItemsResponseJsonParser : IResponseParser
{
    func parseData(data: Data, source: IItemSource?, sessionConfig: ISessionConfig?) -> [ISitecoreItem]
    {
        var items: [ISitecoreItem] = [] //@igk, is this ok!?
        
        var jsonString = String(data: data, encoding: .utf8)!
        
        //TODO: @igk refactor this!
        if (!jsonString.starts(with: "["))
        {
            jsonString = "[\(jsonString)]"
        }
        
        do
        {
            if let result = (try JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: []) as? Array<[String: Any]>)
            {
                items = result.map({ (elem) -> ISitecoreItem in
                    return ScItem(fields: elem , source: source, sessionConfig: sessionConfig)
                })
                
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        return items
    }
    
    
}
