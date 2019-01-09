//
//  SCMediaItemGridCell.swift
//  ScItemBrowser
//
//  Created by IGK on 1/9/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

class SCMediaItemGridCell: SCItemGridCell
{
    var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var progress: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    var imageLoader: SCMediaCellController?
    
    init(frame: CGRect, customSession:SscSession)
    {
        super.init(frame: frame)
        self.setupUI()
        self.imageLoader = SCMediaCellController(customSession: customSession, delegate: self)
    }
    
    override init(frame: CGRect)
    {
        fatalError("init(frame:) has not been implemented, use init(frame:customSession:) instead")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        var imageFrame = self.contentView.frame
        imageFrame.origin = CGPoint(x: 0, y: 0)
        
        self.imageView.frame = imageFrame
        self.progress.center = CGPoint(x: imageFrame.size.width/2, y: imageFrame.size.height/2)
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(progress)
    }
    
    override func setModel(item: ISitecoreItem) {
        self.imageLoader?.setModel(item: item)
    }
    
    override func reloadData() {
        self.imageLoader?.reloadData()
    }
    
    func startLoading()
    {
        self.addSubview(self.progress)
        self.progress.startAnimating()
    }
    
    func stopLoading()
    {
        self.progress.stopAnimating()
        self.progress.removeFromSuperview()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.progress.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        var imageFrame = self.contentView.frame
        imageFrame.origin = CGPoint(x: 0, y: 0)
        
        self.imageView.frame = imageFrame
    }
}

extension SCMediaItemGridCell: SCMediaCellDelegate
{
    func didStartLoadingImageInMediaCellController(sender: SCMediaCellController) {
        self.imageView.image = nil
        self.startLoading()
        self.setNeedsLayout()
    }
    
    func mediaCellController(_ sender: SCMediaCellController, didFinishLoadingImage image: UIImage, forItem mediaItem: ISitecoreItem) {
        self.stopLoading()
        self.imageView.image = image
        self.setNeedsLayout()
    }
    
    func mediaCellController(_ sender: SCMediaCellController, didFailLoadingImageForItem mediaItem: ISitecoreItem?, withError error: Error) {
        self.stopLoading()
        print("image loading failed for item \(String(describing: mediaItem)). Error: \(error.localizedDescription)")
    }
    
    
}
