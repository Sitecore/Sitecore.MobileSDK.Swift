
import Foundation
import SitecoreSSC_SDK

/**
 Since SCItemListBrowser overrides the UITableViewDelegate and UITableViewDataSource protocols, there should be some way to configure cells appearance.
 
 Override methods of this protocol to forward your values to the UITableView and customize its appearance.
 */
#warning ("@igk all this should be optional")
@objc public protocol SIBListModeAppearance: NSObjectProtocol
{
    /**
     Sets the title to the header of the only table view section. If [SIBListModeAppearance levelHeaderViewForTableViewSectionOfItemsBrowser:] is specified this one will be ignored.
     See [UITableViewDataSource tableView:titleForHeaderInSection:] for details.
     
     @param sender An instance of the SCItemListBrowser controller
     
     @return header title. It will be forwarded to [UITableViewDataSource tableView:titleForHeaderInSection:]
     */
    @objc optional func levelHeaderTitleForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> String
    
    /**
     Sets the title to the footer of the only table view section. If [SIBListModeAppearance levelFooterViewForTableViewSectionOfItemsBrowser:] is specified this one will be ignored.
     See [UITableViewDataSource tableView:titleForFooterInSection:] for details.
     
     @param sender An instance of the SCItemListBrowser controller
     
     @return header title. It will be forwarded to [UITableViewDataSource tableView:titleForFooterInSection:]
     */
    @objc optional func levelFooterTitleForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> String
    
    /**
     Custom view for header. Will be adjusted to default or specified header height.
     
     @param sender An instance of the SCItemListBrowser controller
     
     @return A custom view for the section header. It will be forwarded to [UITableViewDelegate tableView:viewForHeaderInSection:]
     */
    @objc optional func levelHeaderViewForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> UIView
    
    /**
     Custom view for footer. Will be adjusted to default or specified footer height.
     
     @param sender An instance of the SCItemListBrowser controller.
     
     @return A custom view for the section footer. It will be forwarded to [UITableViewDelegate tableView:viewForFooterInSection:]
     */
    @objc optional func levelFooterViewForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> UIView
    
    /**
     Height of the section header.
     
     @param sender An instance of the SCItemListBrowser controller
     
     @return Height of the section header. It will be forwarded to [UITableViewDelegate tableView:heightForHeaderInSection:]
     */
    @objc optional func levelHeaderHeightForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> CGFloat
    
    /**
     Height of the section footer.
     
     @param sender An instance of the SCItemListBrowser controller.
     
     @return Height of the section footer. It will be forwarded to [UITableViewDelegate tableView:heightForFooterInSection:]
     */
    @objc optional func levelFooterHeightForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> CGFloat

    /**
     Height of the level up cell.
     
     @param sender An instance of the SCItemListBrowser controller.
     @param indexPath NSIndexPath for the level up cell.
     
     @return Height of the level up cell. It will be forwarded to [UITableViewDelegate tableView:heightForRowAtIndexPath:]
     */
    @objc optional func itemsBrowser(_ sender: SCItemListBrowser, levelUpCellHeigtAt indexPath: IndexPath) -> CGFloat
    
    /**
     Height of the item cell. Feel free to make it different for various types of items.
     
     @param sender An instance of the SCItemListBrowser controller.
     @param item An item to be rendered in this cell.
     @param indexPath NSIndexPath for the item cell.
     
     @return Height of the item cell. It will be forwarded to [UITableViewDelegate tableView:heightForRowAtIndexPath:]
     */
    @objc optional func itemsBrowser(_ sender: SCItemListBrowser, heightOfCellFor item: ISitecoreItem, at indexPath: IndexPath) -> CGFloat
}
