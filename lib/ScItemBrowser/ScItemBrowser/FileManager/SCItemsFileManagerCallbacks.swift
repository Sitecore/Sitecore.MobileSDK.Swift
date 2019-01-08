//
//  SCItemsFileManagerCallbacks.swift
//  ScItemBrowser
//
//  Created by IGK on 12/6/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

typealias OnLevelLoadedBlock = (SCLevelResponse?, SscError?) -> Void
typealias OnLevelProgressBlock = (Any?) -> Void

class SCItemsFileManagerCallbacks {
    
    var onLevelLoadedBlock: OnLevelLoadedBlock?
    var onLevelProgressBlock: OnLevelProgressBlock?
    
}
