//
//  SCItemGridTextCell.swift
//  ScItemBrowser
//
//  Created by IGK on 1/9/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

class SCItemGridTextCell: SCItemGridCell
{
    var label: UILabel?
    var displayName: String?
    
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
    
    override func setModel(item: ISitecoreItem)
    {
        self.displayName = item.displayName
    }
    
    override func reloadData()
    {
        self.label!.text = self.displayName
    }

}
