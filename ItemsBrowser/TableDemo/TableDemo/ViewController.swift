
import UIKit
import SitecoreSSC_SDK
import ScItemBrowser

class ViewController: UIViewController, URLSessionDelegate
{
    let instanceUrl = "https://my-site.net"
    let userName = "myuser"
    let userPassword = "mypassword"
    let domain = "Sitecore"
    
    
    let ODATA_API_KEY    = "5EECEACF-9B11-46D6-8DD4-EC440298BA47"
    let LEVEL_UP_CELL_ID = "ios.Sitecore.MobileSdk.ItemsBrowser.List.LevelUpCell"
    let ITEM_CELL_ID     = "ios.Sitecore.MobileSdk.ItemsBrowser.List.ItemCell"
    let IMAGE_CELL_ID    = "ios.Sitecore.MobileSdk.ItemsBrowser.List.ItemCell.Image"
    
    var sscSession: ISSCReadWriteSession?
    var urlSession: URLSession?
    
    @IBOutlet weak var itemsBrowserController: SCItemListBrowser!
    
    @IBOutlet weak var itemPathLabel: UILabel!
    @IBOutlet var loadingProgress: UIActivityIndicatorView?
    @IBOutlet var rootButton: UIButton?
    @IBOutlet var reloadButton: UIButton?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.startLoading()
        self.createSession()
    }
    
    func createSession()
    {
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let credentials = SCCredentials(username: userName, password: userPassword, domain: domain)
        
        sscSession = ScSessionBuilder.readWriteSession(instanceUrl)
                                     .customUrlSession(urlSession!)
                                     .credentials(credentials)
                                     .build()
        
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

        let getItemRequest = ScRequestBuilder.getItemByIdRequest("11111111-1111-1111-1111-111111111111")
                                             .database("web")
                                             .language("en")
                                             .build()
        
        sscSession.sendGetItemsRequest(getItemRequest) { result in
            
            switch result
            {
            case .success(let response):
                
                print("\(String(describing: response?.items[0].displayName)))")
                self.endLoading()
                self.didLoadRootItem((response?.items[0])!)
                
            case .failure(let error):
                print("network error: \(error) ")
            }
            
        }

    }
    
    func didLoadRootItem(_ item: ISitecoreItem)
    {
        self.itemsBrowserController.setRootItem(item)
        self.itemsBrowserController.reloadData()
    }
    
    func resultReceived(result: Result<IItemsResponse?, SSCError> )
    {
        switch result
        {
        case .success(let response):
            
            let item = response?.items[0]
            print("item display name: \(String(describing: item?.displayName))")
            
        case .failure(let error):
            print("error received: \(error.localizedDescription)")
        }
    }

    #warning ("!!!IGNORING SSL VERIFICATION!!!")
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate)
        {
            completionHandler(.rejectProtectionSpace, nil)
        }
        
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
    }
    
    func startLoading()
    {
        DispatchQueue.main.async
        {
            self.loadingProgress?.isHidden = false
            self.loadingProgress?.startAnimating()
        }
    }
    
    func endLoading()
    {
        DispatchQueue.main.async
        {
            self.loadingProgress?.stopAnimating()
            self.loadingProgress?.isHidden = true
        }
    }

    @IBAction func RootTouched(_ sender: Any)
    {
        guard self.itemsBrowserController.rootItem != nil else
        {
            print("root item is not set")
            return
        }
        
        self.itemsBrowserController.navigateToRootItem()
        
    }
    
    @IBAction func ReloadTouched(_ sender: Any)
    {
        self.itemsBrowserController.forceRefreshData()
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
        print("ups: \(error.debugDescription)")
        self.endLoading()
    }
    
    func itemsBrowser(_ itemsBrowser: Any, shouldLoadLevelForItem levelParentItem: ISitecoreItem) -> Bool
    {
        return levelParentItem.hasChildren
    }
    
    func itemsBrowser(_ itemsBrowser: Any, didLoadLevelForItem levelParentItem: ISitecoreItem)
    {
        self.endLoading()

        let topPath = IndexPath(row: 0, section: 0)
        
        guard let tableView = self.itemsBrowserController.tableView else
        {
            print("!!! itemsBrowser was not initialized properly !!!")
            return
        }
        
        DispatchQueue.main.async
        {
            self.itemPathLabel.text = levelParentItem.path
            tableView.scrollToRow(at: topPath, at: UITableView.ScrollPosition.top, animated: false)
        }
    }
    
    @objc func headerButtonTouched(sender: UIButton)
    {
        self.showAlertWith(message: "Header touched")
    }
    
    @objc func footerButtonTouched(sender: UIButton)
    {
        self.showAlertWith(message: "Footer touched")
    }
    
    func showAlertWith(message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: SIBListModeAppearance
{
    
    func levelHeaderTitleForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> String
    {
        return "level Header"
    }
    
    func levelFooterTitleForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> String
    {
        return "level Footer"
    }
    
    func levelHeaderViewForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> UIView
    {
        let result = UIButton(type: .detailDisclosure)
        result.setTitle("  header custom Button", for: .normal)
        result.addTarget(self, action: #selector(headerButtonTouched(sender:)), for: .touchUpInside)
        return result
    }
    
    func levelFooterViewForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> UIView
    {
        let result = UIButton(type: .detailDisclosure)
        result.setTitle("  footer custom Button", for: .normal)
        result.addTarget(self, action: #selector(footerButtonTouched(sender:)), for: .touchUpInside)
        return result
    }
  
    func levelHeaderHeightForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> CGFloat
    {
     return 100
    }
    
    func levelFooterHeightForTableViewSectionOfItemsBrowser(_ sender: SCItemListBrowser) -> CGFloat
    {
        return 50
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, levelUpCellHeigtAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, heightOfCellFor item: ISitecoreItem, at indexPath: IndexPath) -> CGFloat
    {
        if (item.isMediaImage)
        {
            return 100
        }
        
        return 44
    }
   
}

extension ViewController: SIBListModeCellFactory
{
    
    func createLevelUpCellForListModeOfItemsBrowser(_ sender: SCItemListBrowser) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: LEVEL_UP_CELL_ID)
        
        cell.textLabel?.text = "🔙"
        
        return cell
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, createListModeCellFor item: ISitecoreItem) -> (UITableViewCell & SCItemCell)
    {
        let cellId: String = self.itemsBrowser(self.itemsBrowserController, itemCellReuseIdentifierFor: item)
        
        let cell: SCItemListCell?
        
        if (item.isMediaImage)
        {
            cell = SCMediaItemListCell(style: .default, reuseIdentifier: cellId)
        }
        else
        {
            cell = SCItemListTextCell(style: .default, reuseIdentifier: cellId)
        }
        
        return cell!
    }
    
    func reuseIdentifierForLevelUpCellOfItemsBrowser(_ sender: SCItemListBrowser) -> String
    {
        return LEVEL_UP_CELL_ID
    }
    
    func itemsBrowser(_ sender: SCItemListBrowser, itemCellReuseIdentifierFor item: ISitecoreItem) -> String
    {
        if (item.isMediaImage)
        {
            return IMAGE_CELL_ID
        }
        
        return ITEM_CELL_ID
    }
    
}
