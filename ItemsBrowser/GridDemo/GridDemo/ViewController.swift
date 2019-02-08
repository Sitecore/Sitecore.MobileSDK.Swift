//
//  ViewController.swift
//  GridDemo
//
//  Created by IGK on 1/9/19.
//  Copyright © 2019 Sitecore. All rights reserved.
//

import UIKit
import SitecoreSSC_SDK
import ScItemBrowser

class ViewController: UIViewController, URLSessionDelegate
{
    private let LEVEL_UP_CELL_ID    = "net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell"
    private let ITEM_CELL_ID        = "net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell"
    private let IMAGE_CELL_ID       = "net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell.image"
    
    @IBOutlet weak var itemsBrowserController: SCItemGridBrowser!
    @IBOutlet weak var allChildrenRequestBuilder: SIBAllChildrenRequestBuilder!

    @IBOutlet weak var itemPathLabel: UILabel!
    @IBOutlet var loadingProgress: UIActivityIndicatorView?
    @IBOutlet var rootButton: UIButton?
    @IBOutlet var reloadButton: UIButton?
    
    var sscSession: SscSession?
    var urlSession: URLSession?
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
            completionHandler(.rejectProtectionSpace, nil)
        }
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.startLoading()
//        self.createSession()
        
        self.test()
    }
    
    func test()
    {
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let credentials = ScCredentials(username: "admin", password: "b", domain: "Sitecore")
        sscSession = SscSession(url: "https://cms900.pd-test16-1-dk1.dk.sitecore.net", urlSession: urlSession!, autologinCredentials: credentials)
        
        let itemSource = ItemSource(database: "master", language: "en", versionNumber: nil)
        let pagingParams = PagingParameters(itemsPerPage: 100, pageNumber: 0)
        
        let searchItemRequest = StoredQueryRequest(
            itemId: "3D9F0EE2-C2D7-47C3-BCF0-51C92EB5EB31",
            pagingParameters: pagingParams,
            itemSource: itemSource,
            sessionConfig: nil,
            standardFields: false
        )
        
        sscSession!.sendGetItemsRequest(searchItemRequest) { (response, error) in
            print("RESPONSE COUNT: \(response!.items.count)")
        }
        
//        let getItemRequest = GetByPathRequest(
//            itemPath: "/sitecore/content/Home/Plan And Book/Destinations/Asia/Japan/Tokyo/Akihabara",
//            itemSource: itemSource,
//            sessionConfig: nil,
//            standardFields: true)
//
////        getItemRequest.addFieldToReturn("__Owner")
////        getItemRequest.addFieldToReturn("Title")
//
//        sscSession!.sendGetItemsRequest(getItemRequest) { (response, error) in
//            print("RESPONSE COUNT: \(response!.items.count)")
//        }
    }

    func createSession()
    {
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let credentials = ScCredentials(username: "admin", password: "b", domain: "Sitecore")
        sscSession = SscSession(url: "https://cms900.pd-test16-1-dk1.dk.sitecore.net", urlSession: urlSession!, autologinCredentials: credentials)
        
        self.downloadRootItem()
    }
    
    func downloadRootItem()
    {
        self.startLoading()
        
        guard let sscSession = self.sscSession else
        {
            print("create session first!")
            return
        }
        
        self.itemsBrowserController.setApiSession(self.sscSession!)
        
        let itemSource = ItemSource(database: "web", language: "en")
        
        let getItemRequest = GetByIdRequest(
            itemId: "11111111-1111-1111-1111-111111111111",
            itemSource: itemSource,
            sessionConfig: nil,
            standardFields: false
        )
        
        sscSession.sendGetItemsRequest(getItemRequest) { (response, error) in
            
            guard let items = response?.items else
            {
                return
            }
            
            
            if (items.count > 0)
            {
                self.endLoading()
                self.didLoadRootItem(items[0])
            }
        }
    }
    
    func didLoadRootItem(_ item: ISitecoreItem)
    {
        self.itemsBrowserController.setRootItem(item)
        self.startLoading()
        self.itemsBrowserController.reloadData()
    }

    func startLoading()
    {
        DispatchQueue.main.async
        {
            self.loadingProgress!.isHidden = false
            self.loadingProgress!.startAnimating()
        }
    }
    
    func endLoading()
    {
        DispatchQueue.main.async
        {
            self.loadingProgress!.stopAnimating()
            self.loadingProgress!.isHidden = true
        }
    }

}

extension ViewController: SCItemsBrowserDelegate
{
    func itemsBrowser(_ itemsBrowser: Any, didReceiveLevelProgressNotification progressInfo: Any)
    {
        self.startLoading()
    }
    
    func itemsBrowser(_ itemsBrowser: Any, levelLoadingFailedWithError error: NSError?)
    {
        print("levelLoadingFailedWithError \(String(describing: error?.description))")
    }
    
    func itemsBrowser(_ itemsBrowser: Any, shouldLoadLevelForItem levelParentItem: ISitecoreItem) -> Bool
    {
        return levelParentItem.hasChildren
    }
    
    func itemsBrowser(_ itemsBrowser: Any, didLoadLevelForItem levelParentItem: ISitecoreItem)
    {
        self.endLoading()
        
        DispatchQueue.main.async
        {
            self.itemPathLabel.text = levelParentItem.path
        }
        
        let top = IndexPath(row: 0, section: 0)
        
        DispatchQueue.main.async
        {
            self.itemsBrowserController.collectionView.scrollToItem(at: top, at: .top, animated: false)
        }
    }
    
}

extension ViewController: SIBGridModeAppearance
{
    
}

extension ViewController: SIBGridModeCellFactory
{
    func levelUpCellReuseId() -> String
    {
        return LEVEL_UP_CELL_ID
    }
    
    func reuseIdentifier(for item: ISitecoreItem) -> String
    {
        if (item.isMediaImage)
        {
            return IMAGE_CELL_ID
        }
        
        return ITEM_CELL_ID
    }

    func levelUpCellClass() -> AnyClass
    {
        return SCDefaultLevelUpGridCell.self
    }
    
    func cellClass(for item: ISitecoreItem) -> AnyClass
    {
        if (item.isMediaImage)
        {
            return SCMediaItemGridCell.self
        }
        
        return SCItemGridTextCell.self
    }
    
    func itemsBrowser(_ sender: SCItemGridBrowser, createLevelUpCellAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let reuseId = self.levelUpCellReuseId()
        
        let collectionView = self.itemsBrowserController.collectionView
        collectionView?.register(self.levelUpCellClass(), forCellWithReuseIdentifier: reuseId)
        
        let result: SCDefaultLevelUpGridCell = collectionView?.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! SCDefaultLevelUpGridCell
        DispatchQueue.main.async {
            result.setLevelUpText("🔙")
        }
        return result
    }
    
    func itemsBrowser(_ sender: SCItemGridBrowser, createGridModeCellFor item: ISitecoreItem, at indexPath: IndexPath) -> UICollectionViewCell & SCItemCell
    {
        let reuseId = self.reuseIdentifier(for: item)
        
        let collectionView = self.itemsBrowserController.collectionView
        collectionView?.register(self.cellClass(for: item), forCellWithReuseIdentifier: reuseId)
        
        let result = collectionView?.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! SCItemGridCell

        result.setBackgroundColorForNormalState(UIColor.white)
        result.setbackgroundColorForHighlightedState(UIColor.lightGray)
        
        return result

    }
    
    
}
