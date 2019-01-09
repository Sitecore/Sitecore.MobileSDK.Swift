//
//  SCLevelResponse.swift
//  ScItemBrowser
//
//  Created by IGK on 12/6/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

class SCLevelResponse {
    
    let levelParentItem: ISitecoreItem
    let levelContentItems: Array<ISitecoreItem>
    
    init(levelParentItem: ISitecoreItem, levelContentItems: Array<ISitecoreItem>) {
        self.levelParentItem = levelParentItem
        self.levelContentItems = levelContentItems
    }
    
    var itemsCount: Int
    {
        get { return self.levelContentItems.count }
    }
}
