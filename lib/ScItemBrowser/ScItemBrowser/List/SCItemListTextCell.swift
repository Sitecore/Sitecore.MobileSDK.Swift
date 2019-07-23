
import Foundation
import SitecoreSSC_SDK

public class SCItemListCell : UITableViewCell, SCItemCell
{
    
    public func setModel(item: ISitecoreItem)
    {
        self.doesNotRecognizeSelector(#function)
    }
    
    public func reloadData()
    {
        self.doesNotRecognizeSelector(#function)
    }
    
}

public class SCItemListTextCell: SCItemListCell
{
    var itemName: String = ""
    
    public override func setModel(item: ISitecoreItem)
    {
        self.itemName = item.displayName
    }
    
    public override func reloadData()
    {
        if let label = self.textLabel
        {
            label.text = self.itemName
        }
    }
    
    
}
