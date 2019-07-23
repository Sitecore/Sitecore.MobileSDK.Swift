
import Foundation
import SitecoreSSC_SDK

/**
 A UICollectionViewCell cell that is capable of rendering item's content.
 For custom behaviour you should subclass it and override methods below :
 
 - setModel:
 - reloadData
 
 For default behaviours please consider sub-classes from the list below :
 
 - SCItemGridTextCell
 - SCMediaItemGridCell
 
 
 We have added some background color animations to this sub-class to make the demo application UI look more responsive. If you need some advanced effects, please override the [UICollectionViewCell setHighlighted:] method in your sub-classes.
 */

public class SCItemGridCell: UICollectionViewCell, SCItemCell, SCHighlightableBackgroundGridCell
{
    var backgroundColorForNormalState: UIColor?
    var backgroundColorForHighlightedState: UIColor?
    
    override public var isHighlighted: Bool
    {
        didSet
        {
            SCGridCellBackgroundHighlightingAnimation.playAnimationForCell(self, toHighlight: self.isHighlighted)
        }
    }
    
    public func setBackgroundColorForNormalState(_ color: UIColor)
    {
        self.backgroundColorForNormalState = color
        self.backgroundColor = color
    }
    
    public func setbackgroundColorForHighlightedState(_ color: UIColor)
    {
        self.backgroundColorForHighlightedState = color
    }

    public func setModel(item: ISitecoreItem)
    {
        doesNotRecognizeSelector(#function)
    }
    
    public func reloadData()
    {
        doesNotRecognizeSelector(#function)
    }
    
    
}
