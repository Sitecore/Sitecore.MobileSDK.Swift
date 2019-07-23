
import Foundation

protocol SCHighlightableBackgroundGridCell
{
    var backgroundColorForNormalState: UIColor? {get}
    var backgroundColorForHighlightedState: UIColor? {get}
    
    func setBackgroundColorForNormalState(_ color: UIColor)
    func setbackgroundColorForHighlightedState(_ color: UIColor)

}
