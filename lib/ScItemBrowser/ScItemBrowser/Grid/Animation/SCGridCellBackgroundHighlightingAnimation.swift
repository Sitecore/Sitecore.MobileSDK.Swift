//
//  SCGridCellBackgroundHighlightingAnimation.swift
//  ScItemBrowser
//
//  Created by IGK on 1/9/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

class SCGridCellBackgroundHighlightingAnimation
{
    static func playAnimationForCell(_ cell: (UICollectionViewCell & SCHighlightableBackgroundGridCell), toHighlight: Bool)
    {
//        if (cell.isHighlighted == toHighlight)
//        {
//            return
//        }
        
        var newColor: UIColor?
        
        if (toHighlight)
        {
            newColor = cell.backgroundColorForHighlightedState
        }
        else
        {
            newColor = cell.backgroundColorForNormalState
        }
        
        UIView.animate(withDuration: 0.2) {
            cell.backgroundColor = newColor
        }
    }
}
