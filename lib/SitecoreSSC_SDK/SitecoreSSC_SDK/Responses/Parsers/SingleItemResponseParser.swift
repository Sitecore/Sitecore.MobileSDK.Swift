
import Foundation

class SingleItemResponseParser : IResponseParser
{
    func parseData(data: Data, sessionConfig: ISessionConfig?, source: IItemSource?) -> [ISitecoreItem]
    {
        var items: [ISitecoreItem] = []
        
        do
        {
            if let result = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])
            {
                items = [SCItem(fields: result, sessionConfig: sessionConfig, source: source)]
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        return items
    }
}
