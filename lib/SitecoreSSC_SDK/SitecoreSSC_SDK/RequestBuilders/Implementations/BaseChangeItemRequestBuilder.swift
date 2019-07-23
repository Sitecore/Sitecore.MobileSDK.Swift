
import Foundation


public class BaseChangeItemRequestBuilder<T: IChangeRequest>: BaseRequestBuilder<T>
{
    internal var fieldsToChangeList: [String : String] = [:]
    
    public func addFieldsToChange(_ value: String, forKey key: String) -> Self
    {
        self.fieldsToChangeList.updateValue(value, forKey: key)
        
        return self
    }
    
    public func addFieldsToChange(_ value: [String: String]) -> Self
    {
        fieldsToChangeList.merge(value) { (current, _) -> String in
            current
        }
        
        return self
    }
    
    //Compatibility
    
    public override func database(_ value: String) -> Self
    {
        _ = super.database(value)
        return self
    }
    
    public override func language(_ value: String) -> Self
    {
        _ = super.language(value)
        return self
    }
    
    public override func versionNumber(_ value: NSNumber) -> Self
    {
        _ = super.versionNumber(value)
        return self
    }
}
