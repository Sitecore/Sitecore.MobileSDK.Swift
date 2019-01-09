//
//  SCItemListBrowser.swift
//  ScItemBrowser
//
//  Created by IGK on 12/5/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

public class SCItemListBrowser: SCAbstractItemsBrowser {
   
    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet public weak var listModeTheme: SIBListModeAppearance! 
    @IBOutlet public weak var listModeCellBuilder: SIBListModeCellFactory!

    public func setTableView(_ tableView: UITableView){
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
    }
    
    public func setListModeTheme(_ listModeTheme: SIBListModeAppearance){
        self.listModeTheme = listModeTheme
    }
    
    public func setListModeCellBuilder(_ listModeCellBuilder: SIBListModeCellFactory){
        self.listModeCellBuilder = listModeCellBuilder
    }
    
    override func reloadContentView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func reloadDataIgnoringCache(_ shouldIgnoreCache: Bool){
        super.reloadDataIgnoringCache(shouldIgnoreCache)
    }
    
    deinit{
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
}


extension SCItemListBrowser: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItemIndex: Int = indexPath.row
        let selectedItem = self.loadedLevel?.levelContentItems[selectedItemIndex]

        self.didSelectItem(selectedItem as! ISitecoreItem, at: indexPath)
    }
    
}


extension SCItemListBrowser: UITableViewDataSource {
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let loadedLevel = self.loadedLevel else
        {
            return 0
        }
        
        return loadedLevel.itemsCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let LEVEL_UP_CELL_ID = self.listModeCellBuilder?.reuseIdentifierForLevelUpCellOfItemsBrowser(self)
        
        let itemIndex = indexPath.row

        let itemForCell = loadedLevel!.levelContentItems[itemIndex]
        
        if (type(of: itemForCell) == SCLevelUpItem.self) {
            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: LEVEL_UP_CELL_ID!)
            if nil == cell {
                cell = listModeCellBuilder?.createLevelUpCellForListModeOfItemsBrowser(self)
            }
            return cell!
        }
        else
        {
            let castedItem = itemForCell as! ISitecoreItem
            let ITEM_CELL_ID = self.listModeCellBuilder?.itemsBrowser(self, itemCellReuseIdentifierFor: castedItem)
            
            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ITEM_CELL_ID!)
            
            var itemCell: (UITableViewCell & SCItemCell)? = nil
            if nil == cell {
                itemCell = self.listModeCellBuilder!.itemsBrowser(self, createListModeCellFor: castedItem)
                cell = itemCell
            } else {
                itemCell = cell as? (UITableViewCell & SCItemCell)
            }

            itemCell?.setModel(item: castedItem)
            itemCell?.reloadData()
            
            return cell!
        }
    }
    
    //MARK: -
    //MARK: Appearance
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if (self.listModeTheme.responds(to: #selector(SIBListModeAppearance.levelHeaderTitleForTableViewSectionOfItemsBrowser(_:))))
        {
            return self.listModeTheme.levelHeaderTitleForTableViewSectionOfItemsBrowser!(self)
        }
        
        return nil
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        if (self.listModeTheme.responds(to: #selector(SIBListModeAppearance.levelFooterTitleForTableViewSectionOfItemsBrowser(_:))))
        {
            return self.listModeTheme.levelFooterTitleForTableViewSectionOfItemsBrowser!(self)
        }
        
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if (self.listModeTheme.responds(to: #selector(SIBListModeAppearance.levelHeaderViewForTableViewSectionOfItemsBrowser(_:))))
        {
            return self.listModeTheme.levelHeaderViewForTableViewSectionOfItemsBrowser!(self)
        }
        
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        if (self.listModeTheme.responds(to: #selector(SIBListModeAppearance.levelFooterViewForTableViewSectionOfItemsBrowser(_:))))
        {
            return self.listModeTheme.levelFooterViewForTableViewSectionOfItemsBrowser!(self)
        }
        
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let  selectedItem = self.loadedLevel?.levelContentItems[indexPath.row]
        
        if (type(of: selectedItem) == SCLevelUpItem.self)
        {
            if (self.listModeTheme.responds(to: #selector(SIBListModeAppearance.itemsBrowser(_:levelUpCellHeigtAt:))))
            {
                return self.listModeTheme.itemsBrowser!(self, levelUpCellHeigtAt: indexPath)
            }
        }
        else
        {
            if (self.listModeTheme.responds(to: #selector(SIBListModeAppearance.itemsBrowser(_:heightOfCellFor:at:))))
            {
                return self.listModeTheme.itemsBrowser!(self, heightOfCellFor: selectedItem as! ISitecoreItem, at: indexPath)
            }
        }
        
        return -1
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        if (self.listModeTheme.responds(to: #selector(SIBListModeAppearance.levelHeaderHeightForTableViewSectionOfItemsBrowser(_:))))
        {
            return self.listModeTheme.levelHeaderHeightForTableViewSectionOfItemsBrowser!(self)
        }
        
        return -1
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if (self.listModeTheme.responds(to: #selector(SIBListModeAppearance.levelFooterHeightForTableViewSectionOfItemsBrowser(_:))))
        {
            return self.listModeTheme.levelFooterHeightForTableViewSectionOfItemsBrowser!(self)
        }
        
        return -1
    }
    
    
}
