//
//  SCLevelInfoPOD.swift
//  ScItemBrowser
//
//  Created by IGK on 12/6/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

class SCLevelInfoPOD {

    let levelRequest: IGetChildrenRequest
    let levelParentItem: ISitecoreItem
    
    init(levelRequest: IGetChildrenRequest, item: ISitecoreItem) {
        self.levelRequest = levelRequest
        self.levelParentItem = item
    }
    
    
}

