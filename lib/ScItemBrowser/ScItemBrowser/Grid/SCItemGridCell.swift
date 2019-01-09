//
//  SCItemGridCell.swift
//  ScItemBrowser
//
//  Created by IGK on 1/9/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

/**
 A UICollectionViewCell cell that is capable of rendering item's content.
 For custom behaviour you should subclass it and override methods below :
 
 - setModel:
 - reloadData
 
 For default behaviours please consider sub-classes from the list below :
 
 - SCItemGridTextCell
 - SCMediaItemGridCell
 
 
 We have added some background color animations to this sub-class to make the demo application UI look more responsive. If you need some advanced effects, please override the [UICollectionViewCell setHighlighted:] method in your sub-classes.
 */

class SCItemGridCell: UICollectionViewCell, SCItemCell, SCHighlightableBackgroundGridCell
{
    
    var backgroundColorForNormalState: UIColor?
    
    var backgroundColorForHighlightedState: UIColor?
    
    override var isHighlighted: Bool {
        didSet
        {
            SCGridCellBackgroundHighlightingAnimation.playAnimationForCell(self, toHighlight: self.isHighlighted)
        }
    }
    
    func setBackgroundColorForNormalState(_ color: UIColor) {
        self.backgroundColorForNormalState = color
        self.backgroundColor = color
    }
    
    func backgroundColorForHighlightedState(_ color: UIColor) {
        self.backgroundColorForHighlightedState = color
    }

    func setModel(item: ISitecoreItem) {
        doesNotRecognizeSelector(#function)
    }
    
    func reloadData() {
        doesNotRecognizeSelector(#function)
    }
    
    
}
