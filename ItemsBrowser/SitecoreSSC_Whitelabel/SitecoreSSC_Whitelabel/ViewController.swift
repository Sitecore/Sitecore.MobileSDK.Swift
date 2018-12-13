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

class ViewController: UIViewController, URLSessionDelegate, UITableViewDelegate {

    let LEVEL_UP_CELL_ID = "net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell"
    let ITEM_CELL_ID     = "net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell"
    let IMAGE_CELL_ID     = "net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell.image"
    
    var sscSession: SscSession?
    var urlSession: URLSession?
    
    var itemsBrowserController: SCItemListBrowser?
    //var allChildrenRequestBuilder: SIBAllChildrenRequestBuilder?
    var itemPathTextView: UITextView?
    var loadingProgress: UIActivityIndicatorView?
    var rootButton: UIButton?
    var reloadButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        sscSession = SscSession(url: "https://tst90170928.test24dk1.dk.sitecore.net", urlSession: urlSession!)
        
        let credentials = ScCredentials(username: "admin", password: "b", domain: "Sitecore")
        let itemSource = ItemSource(database: "web", language: "en")
        
        let loginRequest = LoginRequest(credentils: credentials)
        
        self.sscSession!.sendLoginRequest(request: loginRequest) { (response, error) in
            print("\(String(describing: response))")
            
            
            let getItemRequest = GetByIdRequest(
                itemId: "110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9",
                itemSource: itemSource,
                sessionConfig: nil,
                queryParameters: nil,
                standardFields: false
            )

            self.sscSession!.sendGetItemsRequest(request: getItemRequest) { (response, error) in
                print("\(response?.items[0].displayName))")
            }
            
            let getChildren = GetChildrenRequest(
                parentId: "110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9",
                pagingParameters: nil,
                itemSource: itemSource,
                sessionConfig: nil,
                queryParameters: nil,
                standardFields:false
            )
            
            self.sscSession!.sendGetItemsRequest(request: getChildren) { (response, error) in
                print("GET CHILDREN, COUNT: \(response?.items.count)")
                print("\(response?.items[0].displayName))")
            }
            
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
        self.loadingProgress!.isHidden = false
        self.loadingProgress!.startAnimating()
    }
    
    func endLoading()
    {
        self.loadingProgress!.stopAnimating()
        self.loadingProgress!.isHidden = true
    }

}

extension ViewController: SCItemsBrowserDelegate{
    func itemsBrowser(_ itemsBrowser: Any, didReceiveLevelProgressNotification progressInfo: Any) {
        self.startLoading()
    }
    
    func itemsBrowser(_ itemsBrowser: Any, levelLoadingFailedWithError error: Error?) {
        print("ups: \(error.debugDescription)")
        self.endLoading()
    }
    
    func itemsBrowser(_ itemsBrowser: Any, shouldLoadLevelForItem levelParentItem: ISitecoreItem) -> Bool {
        return levelParentItem.hasChildren
    }
    
    func itemsBrowser(_ itemsBrowser: Any, didLoadLevelForItem levelParentItem: ISitecoreItem) {
        self.endLoading()
        self.itemPathTextView!.text = levelParentItem.path
        let topPath = IndexPath(row: 0, section: 0)
        let tableView: UITableView = self.itemsBrowserController!.tableView!
        tableView.scrollToRow(at: topPath, at: UITableView.ScrollPosition.top, animated: false)
    }
    
}

extension ViewController: SIBListModeAppearance{
    func levelHeaderTitleForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> String {
        return "level Header"
    }
    
    func levelFooterTitleForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> String {
        return "level Footer"
    }
    
    func levelHeaderViewForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> UIView {
        let result = UIButton(type: .infoDark)
        result.setTitle("header custom Button", for: .normal)
        return result
    }
    
    func levelFooterViewForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> UIView {
        let result = UIButton(type: .infoDark)
        result.setTitle("footer custom Button", for: .normal)
        return result
    }
    
    func levelHeaderHeightForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> CGFloat {
     return 100
    }
    
    func levelFooterHeightForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> CGFloat {
        return 50
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, levelUpCellHeigtAt indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, heightOfCellFor item: ISitecoreItem, at indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    
}

extension ViewController: SIBListModeCellFactory{
    
    
    
    func createLevelUpCellForListModeOfItemsBrowser(_ sender: SCItemListBrowser) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: LEVEL_UP_CELL_ID)
        cell.textLabel?.text = "LEVEL_UP_CELL_ID"
        return cell
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, createListModeCellFor item: ISitecoreItem) -> (UITableViewCell & SCItemCell) {
        let cellId: String = self.itemsBrowser(self.itemsBrowserController!, itemCellReuseIdentifierFor: item)
        #warning("@igk implement SCItemListTextCell")
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        return cell as! (UITableViewCell & SCItemCell)
    }
    
    func reuseIdentifierForLevelUpCellOfItemsBrowser(_ sender: SCItemListBrowser) -> String {
        return LEVEL_UP_CELL_ID
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, itemCellReuseIdentifierFor item: ISitecoreItem) -> String {
        return ITEM_CELL_ID
    }
    
    
}
