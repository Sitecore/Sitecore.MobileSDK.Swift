//
//  SCDefaultLevelUpGridCell.swift
//  ScItemBrowser
//
//  Created by IGK on 1/9/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

class SCDefaultLevelUpGridCell: UICollectionViewCell, SCHighlightableBackgroundGridCell
{
    var backgroundColorForNormalState: UIColor?
    var backgroundColorForHighlightedState: UIColor?
    var label: UILabel?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupUI()
    }
    
    func setupUI()
    {
        var labelFrame = self.contentView.frame
        labelFrame.origin = CGPoint(x: 0, y: 0)
        
        self.label = UILabel(frame: labelFrame)
        self.contentView.addSubview(self.label!)
    }
    
    func setBackgroundColorForNormalState(_ color: UIColor) {
        self.backgroundColorForNormalState = color
        self.backgroundColor = color
    }
    
    func backgroundColorForHighlightedState(_ color: UIColor) {
        self.backgroundColorForHighlightedState = color
    }
    
    override var isHighlighted: Bool {
        didSet
        {
            SCGridCellBackgroundHighlightingAnimation.playAnimationForCell(self, toHighlight: self.isHighlighted)
        }
    }
    
}
