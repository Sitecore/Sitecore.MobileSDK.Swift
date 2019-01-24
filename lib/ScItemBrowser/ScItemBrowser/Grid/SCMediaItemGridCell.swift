//
//  SCMediaItemGridCell.swift
//  ScItemBrowser
//
//  Created by IGK on 1/9/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

public protocol SCMediaItemGridCellDelegate {
    func getCustomSession() -> SscSession
}

public class SCMediaItemGridCell: SCItemGridCell
{
    var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var progress: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    var imageLoader: SCMediaCellController?
    var customSession: SscSession? = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }
    
    public func setCustomSession(_ session: SscSession)
    {
        self.customSession = session
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
    
    override public func setModel(item: ISitecoreItem)
    {
        self.imageLoader = SCMediaCellController(customSession: self.customSession, delegate: self)
        self.imageLoader?.setModel(item: item)
    }
    
    override public func reloadData()
    {
        self.imageLoader?.reloadData()
    }
    
    func startLoading()
    {
        DispatchQueue.main.async
        {
            self.addSubview(self.progress)
            self.progress.startAnimating()
        }
    }
    
    func stopLoading()
    {
        DispatchQueue.main.async
        {
            self.progress.stopAnimating()
            self.progress.removeFromSuperview()
        }
    }
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        self.progress.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        var imageFrame = self.contentView.frame
        imageFrame.origin = CGPoint(x: 0, y: 0)
        
        self.imageView.frame = imageFrame
    }
}

extension SCMediaItemGridCell: SCMediaCellDelegate
{
    func didStartLoadingImageInMediaCellController(sender: SCMediaCellController)
    {
        DispatchQueue.main.async
        {
            self.imageView.image = nil
            self.startLoading()
            self.setNeedsLayout()
        }
    }
    
    func mediaCellController(_ sender: SCMediaCellController, didFinishLoadingImage image: UIImage, forItem mediaItem: ISitecoreItem) {
        self.stopLoading()
        DispatchQueue.main.async
        {
            self.imageView.image = image
            self.setNeedsLayout()
        }
    }
    
    func mediaCellController(_ sender: SCMediaCellController, didFailLoadingImageForItem mediaItem: ISitecoreItem?, withError error: Error) {
        self.stopLoading()
        print("image loading failed for item \(String(describing: mediaItem)). Error: \(error.localizedDescription)")
    }
    
    
}
