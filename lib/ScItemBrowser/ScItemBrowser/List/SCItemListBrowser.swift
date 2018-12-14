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
   
    #warning ("@igk make private setter!!!")
    public var tableView: UITableView?
    var listModeTheme: SIBListModeAppearance?
    var listModeCellBuilder: SIBListModeCellFactory?

    public func setTableView(_ tableView: UITableView){
        self.tableView = tableView
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
    }
    
    public func setListModeTheme(_ listModeTheme: SIBListModeAppearance){
        self.listModeTheme = listModeTheme
    }
    
    public func setListModeCellBuilder(_ listModeCellBuilder: SIBListModeCellFactory){
        self.listModeCellBuilder = listModeCellBuilder
    }
    
    override func reloadContentView(){
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    override func reloadDataIgnoringCache(_ shouldIgnoreCache: Bool){
        super.reloadDataIgnoringCache(shouldIgnoreCache)
    }
    
    deinit{
        self.tableView?.delegate = nil
        self.tableView?.dataSource = nil
    }
    
}


extension SCItemListBrowser: UITableViewDelegate {

    
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItemIndex: Int = indexPath.row
        let selectedItem = self.loadedLevel?.levelContentItems[selectedItemIndex]
        
        self.didSelectItem(selectedItem as! ISitecoreItem, at: indexPath)
    }
    
}


extension SCItemListBrowser: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let level = self.loadedLevel else {
            return 0
        }
        
        return level.levelContentItems.count
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
    
    
}
