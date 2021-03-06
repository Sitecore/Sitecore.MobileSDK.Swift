
import Foundation
import SitecoreSSC_SDK

public class SCItemGridTextCell: SCItemGridCell
{
    var label: UILabel?
    var displayName: String?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.setupUI()
    }
    
    func setupUI()
    {
        self.label = nil
        
        var labelFrame = self.contentView.frame
        labelFrame.origin = CGPoint(x: 0, y: 0)
        
        self.label = UILabel(frame: labelFrame)
        self.label?.textAlignment = .center
        self.label?.numberOfLines = 0
        self.label?.font = UIFont.systemFont(ofSize: 10)
        
        self.contentView.addSubview(self.label!)
    }
    
    override public func setModel(item: ISitecoreItem)
    {
        self.displayName = item.displayName
    }
    
    override public func reloadData()
    {
        self.label?.text = self.displayName
    }

}
