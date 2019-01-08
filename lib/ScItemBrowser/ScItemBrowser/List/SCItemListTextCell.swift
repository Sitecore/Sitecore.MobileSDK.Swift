//
//  SCItemListTextCell.swift
//  ScItemBrowser
//
//  Created by IGK on 12/14/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

public class SCItemListCell : UITableViewCell, SCItemCell {
    
    public func setModel(item: ISitecoreItem) {
        self.doesNotRecognizeSelector(#function)
    }
    
    public func reloadData() {
        self.doesNotRecognizeSelector(#function)
    }
    
    
}

public class SCItemListTextCell: SCItemListCell {
    
    var itemName: String?
    
    public override func setModel(item: ISitecoreItem) {
        self.itemName = item.displayName
    }
    
    public override func reloadData() {
        DispatchQueue.main.async {
            self.textLabel?.text = self.itemName
        }
    }
    
    
}
