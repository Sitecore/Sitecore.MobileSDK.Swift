//
//  SCItemsFileManagerCallbacks.swift
//  ScItemBrowser
//
//  Created by IGK on 12/6/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

typealias OnLevelLoadedBlock = (SCLevelResponse?, Error?) -> Void
typealias OnLevelProgressBlock = (Any?) -> Void

class SCItemsFileManagerCallbacks {
    
    var onLevelLoadedBlock: OnLevelLoadedBlock?
    var onLevelProgressBlock: OnLevelProgressBlock?
    
}
