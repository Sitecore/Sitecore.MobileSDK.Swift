
import Foundation

public class SCDefaultLevelUpGridCell: UICollectionViewCell, SCHighlightableBackgroundGridCell
{
    var backgroundColorForNormalState: UIColor?
    var backgroundColorForHighlightedState: UIColor?
    var label: UILabel?
    
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
        var labelFrame = self.contentView.frame
        labelFrame.origin = CGPoint(x: 0, y: 0)
        
        self.label = UILabel(frame: labelFrame)
        self.contentView.addSubview(self.label!)
    }
    
    public func setLevelUpText(_ text: String)
    {
        guard let label = self.label else
        {
            return
        }
        
        label.textAlignment = .center
        label.text = text
    }
    
    func setBackgroundColorForNormalState(_ color: UIColor)
    {
        self.backgroundColorForNormalState = color
        self.backgroundColor = color
    }
    
    func setbackgroundColorForHighlightedState(_ color: UIColor)
    {
        self.backgroundColorForHighlightedState = color
    }
    
    override public var isHighlighted: Bool
    {
        didSet
        {
            SCGridCellBackgroundHighlightingAnimation.playAnimationForCell(self, toHighlight: self.isHighlighted)
        }
    }
    
}
