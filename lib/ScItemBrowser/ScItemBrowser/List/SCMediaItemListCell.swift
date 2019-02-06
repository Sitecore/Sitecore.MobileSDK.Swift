//
//  SCMediaItemListCell.swift
//  ScItemBrowser
//
//  Created by IGK on 12/20/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation
import SitecoreSSC_SDK

protocol SCMediaCellDelegate: class
{
    
    func didStartLoadingImageInMediaCellController(sender: SCMediaCellController)
    func mediaCellController(_ sender: SCMediaCellController, didFinishLoadingImage image: UIImage, forItem mediaItem: ISitecoreItem)
    func mediaCellController(_ sender: SCMediaCellController, didFailLoadingImageForItem mediaItem: ISitecoreItem?, withError error: Error)
    
}

public class SCMediaItemListCell: SCItemListCell, SCMediaCellDelegate
{
    private let progress: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    private var imageLoader: SCMediaCellController?
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.imageLoader = SCMediaCellController(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.imageLoader = SCMediaCellController(delegate: self)
    }
    
    public func setCustomSession(_ session: SscSession)
    {
        if (self.imageLoader != nil)
        {
            self.imageLoader!.cancelImageLoading()
        }
        
        self.imageLoader = SCMediaCellController(customSession: session, delegate: self)
    }

    override public func setModel(item: ISitecoreItem)
    {
        self.imageLoader!.setModel(item: item)
    }
    
    override public func reloadData()
    {
        self.imageLoader!.reloadData()
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
            print("!!! \(self.progress.description) removed from superview")
        }
    }
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        self.progress.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
    }
    
    //MARK: -
    //MARK: SCMediaCellDelegate

    func didStartLoadingImageInMediaCellController(sender: SCMediaCellController)
    {
        print("mediaCellController didStartLoadingImageInMediaCellController")
        
        guard let imageView = self.imageView else
        {
            return
        }
        
        imageView.image = nil
        
        guard let textLabel = self.textLabel else
        {
            return
        }
        
        textLabel.text = self.imageLoader!.item!.displayName
        
        self.startLoading()
        self.setNeedsLayout()
    }
    
    func mediaCellController(_ sender: SCMediaCellController, didFinishLoadingImage image: UIImage, forItem mediaItem: ISitecoreItem)
    {
        print("mediaCellController didFinishLoadingImage")
        self.stopLoading()

        DispatchQueue.main.async
        {
            guard let imageView = self.imageView else
            {
                return
            }
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            self.setNeedsLayout()
        }
    }
    
    func mediaCellController(_ sender: SCMediaCellController, didFailLoadingImageForItem mediaItem: ISitecoreItem?, withError error: Error)
    {
        DispatchQueue.main.async
        {
            self.stopLoading()
            self.setNeedsLayout()
        }
        print(error.localizedDescription)
    }
    
}
