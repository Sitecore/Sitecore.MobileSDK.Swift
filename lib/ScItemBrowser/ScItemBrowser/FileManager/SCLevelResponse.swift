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
    let levelContentItems: Array<Any>
    
    init(levelParentItem: ISitecoreItem, levelContentItems: Array<Any>) {
        self.levelParentItem = levelParentItem
        self.levelContentItems = levelContentItems
    }
}
