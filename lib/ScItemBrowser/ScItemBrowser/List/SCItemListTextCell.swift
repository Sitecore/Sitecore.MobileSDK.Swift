//
//  SCItemListTextCell.swift
//  ScItemBrowser
//
//  Created by IGK on 12/14/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

public class SCItemListTextCell: UITableViewCell, SCItemCell {
    
    var itemName: String?
    
    public func setModel(item: ISitecoreItem) {
        self.itemName = item.displayName
    }
    
    public func reloadData() {
        DispatchQueue.main.async {
            self.textLabel?.text = self.itemName
        }
    }
    
    
}
