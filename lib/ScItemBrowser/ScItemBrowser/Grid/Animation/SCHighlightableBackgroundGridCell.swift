//
//  SCHighlightableBackgroundGridCell.swift
//  ScItemBrowser
//
//  Created by IGK on 1/9/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

protocol SCHighlightableBackgroundGridCell
{
    var backgroundColorForNormalState: UIColor? {get}
    var backgroundColorForHighlightedState: UIColor? {get}
    
    func setBackgroundColorForNormalState(_ color: UIColor)
    func backgroundColorForHighlightedState(_ color: UIColor)

}
