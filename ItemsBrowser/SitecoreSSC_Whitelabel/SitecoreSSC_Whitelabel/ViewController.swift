//
//  ViewController.swift
//  SitecoreSSC_Whitelabel
//
//  Created by IGK on 11/16/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import UIKit
import SitecoreSSC_SDK
import ScItemBrowser

class ViewController: UIViewController, URLSessionDelegate {
    let ODATA_API_KEY    = "5EECEACF-9B11-46D6-8DD4-EC440298BA47"
    let LEVEL_UP_CELL_ID = "net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell"
    let ITEM_CELL_ID     = "net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell"
    let IMAGE_CELL_ID    = "net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell.image"
    
    var sscSession: SscSession?
    var urlSession: URLSession?
    
    
    
    @IBOutlet weak var itemsBrowserController: SCItemListBrowser!
    
    @IBOutlet weak var itemPathLabel: UILabel!
    @IBOutlet var loadingProgress: UIActivityIndicatorView?
    @IBOutlet var rootButton: UIButton?
    @IBOutlet var reloadButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startLoading()
        self.createSession()
    }
    
    func createSession()
    {
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        sscSession = SscSession(url: "https://cms900.pd-test16-1-dk1.dk.sitecore.net", urlSession: urlSession!)
        
        let credentials = ScCredentials(username: "admin", password: "b", domain: "Sitecore")
        
        self.sscSession!.enableAutologinWithCredentials(credentials)
        
        self.downloadRootItem()
    }
    
    func downloadRootItem()
    {
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
        self.itemsBrowserController.reloadData()
    }

    func testDownload(){

        guard let sscSession = self.sscSession else {
            print("create session first!")
            return
        }
        
        let itemSource = ItemSource(database: "web", language: "en")

        let getItemRequest = GetByIdRequest(
            itemId: "4F20B519-D565-4472-B018-91CB6103C667",
            itemSource: itemSource,
            sessionConfig: nil,
            queryParameters: nil,
            standardFields: false
        )

        sscSession.sendGetItemsRequest(getItemRequest) { (response, error) in
            print("!!! GET ITEM BY ID !!! \(String(describing: response?.items[0].displayName))")
        }
        
        let getChildren = GetChildrenRequest(
            parentId: "4B97F784-338B-4EB7-B4B0-09B870A5E0D7",
            pagingParameters: nil,
            itemSource: itemSource,
            sessionConfig: nil,
            queryParameters: nil,
            standardFields: false,
            ignoreCache: false
        )

        sscSession.sendGetItemsRequest(getChildren) { (response, error) in
            print("GET CHILDREN, COUNT: \(String(describing: response?.items.count))")
            if ((response?.items.count)! > 0) { print("\(String(describing: response?.items[0].displayName)))") }
        }
    }
    
    #warning ("!!!IGNORING SSL VERIFICATION!!!")
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
            completionHandler(.rejectProtectionSpace, nil)
        }
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
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

    @IBAction func RootTouched(_ sender: Any) {
        
        guard self.itemsBrowserController.rootItem != nil else {
            print("root item is not set")
            return
        }
        
        self.itemsBrowserController.navigateToRootItem()
        
    }
    
    @IBAction func ReloadTouched(_ sender: Any) {
        self.itemsBrowserController.forceRefreshData()
    }
}

extension ViewController: SCItemsBrowserDelegate{
    func itemsBrowser(_ itemsBrowser: Any, didReceiveLevelProgressNotification progressInfo: Any) {
        self.startLoading()
    }
    
    func itemsBrowser(_ itemsBrowser: Any, levelLoadingFailedWithError error: NSError?) {
        print("ups: \(error.debugDescription)")
        self.endLoading()
    }
    
    func itemsBrowser(_ itemsBrowser: Any, shouldLoadLevelForItem levelParentItem: ISitecoreItem) -> Bool {
        return levelParentItem.hasChildren
    }
    
    func itemsBrowser(_ itemsBrowser: Any, didLoadLevelForItem levelParentItem: ISitecoreItem) {
        self.endLoading()
        DispatchQueue.main.async {
            self.itemPathLabel.text = levelParentItem.path
        }
        let topPath = IndexPath(row: 0, section: 0)
        let tableView: UITableView = self.itemsBrowserController.tableView!
        DispatchQueue.main.async {
            tableView.scrollToRow(at: topPath, at: UITableView.ScrollPosition.top, animated: false)
        }
    }
    
}

extension ViewController: SIBListModeAppearance{
    
    func levelHeaderTitleForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> String {
        return "level Header"
    }
    
    func levelFooterTitleForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> String {
        return "level Footer"
    }
    
//    func levelHeaderViewForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> UIView {
//        let result = UIButton(type: .infoDark)
//        result.setTitle("header custom Button", for: .normal)
//        return result
//    }
//    
//    func levelFooterViewForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> UIView {
//        let result = UIButton(type: .infoDark)
//        result.setTitle("footer custom Button", for: .normal)
//        return result
//    }
    
//    func levelHeaderHeightForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> CGFloat {
//     return 100
//    }
//    
//    func levelFooterHeightForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> CGFloat {
//        return 50
//    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, levelUpCellHeigtAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, heightOfCellFor item: ISitecoreItem, at indexPath: IndexPath) -> CGFloat {
        
        if (item.isMediaImage)
        {
            return 100
        }
        
        return 44
    }
    
    
}

extension ViewController: SIBListModeCellFactory{
    
    func createLevelUpCellForListModeOfItemsBrowser(_ sender: SCItemListBrowser) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: LEVEL_UP_CELL_ID)
        DispatchQueue.main.async {
            cell.textLabel?.text = "🔙"
        }
        return cell
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, createListModeCellFor item: ISitecoreItem) -> (UITableViewCell & SCItemCell)
    {
        let cellId: String = self.itemsBrowser(self.itemsBrowserController, itemCellReuseIdentifierFor: item)
        
        let cell: SCItemListCell?
        
        if (item.isMediaImage) {
            cell = SCMediaItemListCell(style: .default, reuseIdentifier: cellId)
        } else {
            cell = SCItemListTextCell(style: .default, reuseIdentifier: cellId)
        }
        
        return cell!
    }
    
    func reuseIdentifierForLevelUpCellOfItemsBrowser(_ sender: SCItemListBrowser) -> String {
        return LEVEL_UP_CELL_ID
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, itemCellReuseIdentifierFor item: ISitecoreItem) -> String {
        
        if (item.isMediaImage)
        {
            return IMAGE_CELL_ID
        }
        
        return ITEM_CELL_ID
    }
    
    
}
