
import Foundation

class ItemsListResponseJsonParser : IResponseParser
{
    func parseData(data: Data, sessionConfig: ISessionConfig?, source: IItemSource?) -> [ISitecoreItem]
    {
        var items: [ISitecoreItem] = [] //@igk, is this ok!?
        
        do
        {
            if let result = (try JSONSerialization.jsonObject(with: data, options: []) as? Array<[String: Any]>)
            {
                items = result.map({ (elem) -> ISitecoreItem in
                    return SCItem(fields: elem, sessionConfig: sessionConfig, source: source)
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
