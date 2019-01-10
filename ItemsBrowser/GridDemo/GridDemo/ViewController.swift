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
    private let LEVEL_UP_CELL_ID = "net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell"
    private let ITEM_CELL_ID = "net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell"
    private let IMAGE_CELL_ID = "net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell.image"
    
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
        
        self.startLoading()
        self.createSession {
            self.downloadRootItem()
        }
    }

    func createSession(completion: @escaping () -> ())
    {
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        sscSession = SscSession(url: "https://tst90170928.test24dk1.dk.sitecore.net", urlSession: urlSession!)
        
        let credentials = ScCredentials(username: "admin", password: "b", domain: "Sitecore")
        
        let loginRequest = LoginRequest(credentils: credentials)
        
        self.sscSession!.sendLoginRequest(loginRequest) { (response, error) in
            print("\(String(describing: response))")
            completion()
        }
    }
    
    func downloadRootItem(){
        
        self.startLoading()
        
        guard let sscSession = self.sscSession else {
            print("create session first!")
            return
        }
        self.itemsBrowserController.setApiSession(self.sscSession!)
        
        let itemSource = ItemSource(database: "web", language: "en")
        
        let getItemRequest = GetByIdRequest(
            itemId: "11111111-1111-1111-1111-111111111111",
            itemSource: itemSource,
            sessionConfig: nil,
            queryParameters: nil,
            standardFields: false
        )
        
        sscSession.sendGetItemsRequest(getItemRequest) { (response, error) in
            print("\(String(describing: response?.items[0].displayName)))")
            self.endLoading()
            self.didLoadRootItem((response?.items[0])!)
        }
    }
    
    func didLoadRootItem(_ item: ISitecoreItem){
        self.itemsBrowserController.setRootItem(item)
        self.startLoading()
        self.itemsBrowserController.reloadData()
    }

    func startLoading()
    {
        DispatchQueue.main.async {
            self.loadingProgress!.isHidden = false
            self.loadingProgress!.startAnimating()
        }
    }
    
    func endLoading()
    {
        DispatchQueue.main.async {
            self.loadingProgress!.stopAnimating()
            self.loadingProgress!.isHidden = true
        }
    }

}

extension ViewController: SCItemsBrowserDelegate
{
    func itemsBrowser(_ itemsBrowser: Any, didReceiveLevelProgressNotification progressInfo: Any) {
        self.startLoading()
    }
    
    func itemsBrowser(_ itemsBrowser: Any, levelLoadingFailedWithError error: NSError?) {
        print("levelLoadingFailedWithError \(String(describing: error?.description))")
    }
    
    func itemsBrowser(_ itemsBrowser: Any, shouldLoadLevelForItem levelParentItem: ISitecoreItem) -> Bool {
        return levelParentItem.hasChildren
    }
    
    func itemsBrowser(_ itemsBrowser: Any, didLoadLevelForItem levelParentItem: ISitecoreItem)
    {
        self.endLoading()
        
        DispatchQueue.main.async {
            self.itemPathLabel.text = levelParentItem.path
        }
        
        let top = IndexPath(row: 0, section: 0)
        
        DispatchQueue.main.async {
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
            result.setLevelUpText("UP")
        }
        return result
    }
    
    func itemsBrowser(_ sender: SCItemGridBrowser, createGridModeCellFor item: ISitecoreItem, at indexPath: IndexPath) -> UICollectionViewCell & SCItemCell
    {
        let reuseId = self.reuseIdentifier(for: item)
        
        let collectionView = self.itemsBrowserController.collectionView
        collectionView?.register(self.cellClass(for: item), forCellWithReuseIdentifier: reuseId)
        
        let result = collectionView?.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! UICollectionViewCell & SCItemCell
        
//        //@igk spike to transit hacked(no ssl verification) session. I have to do something with this!!!
//        if (item.isMediaImage) {
//            let castedResult: SCMediaItemGridCell = result as! SCMediaItemGridCell
//            castedResult.setCustomSession(self.sscSession!)
//        }
        
        return result

    }
    
    
}
