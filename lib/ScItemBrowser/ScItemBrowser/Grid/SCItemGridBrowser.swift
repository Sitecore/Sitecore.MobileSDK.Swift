
import Foundation
import SitecoreSSC_SDK

public class SCItemGridBrowser: SCAbstractItemsBrowser, SCAbstractItemsBrowserSubclassing
{
    @IBOutlet public weak var collectionView: UICollectionView!
    @IBOutlet public weak var gridModeTheme: SIBGridModeAppearance!
    @IBOutlet public weak var gridModeCellBuilder: SIBGridModeCellFactory!

    deinit{
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
    
    override func reloadContentView()
    {
        DispatchQueue.main.async
            {
                self.collectionView.reloadData()
            }
    }
    
    override func reloadDataIgnoringCache(_ shouldIgnoreCache: Bool)
    {
        super.reloadDataIgnoringCache(shouldIgnoreCache)
    }
    
    func setCollectionView(_ collectionView: UICollectionView)
    {
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func setGridModeTheme(_ gridModeTheme: SIBGridModeAppearance)
    {
        self.gridModeTheme = gridModeTheme
    }
    
    func setGridModeCellBuilder(_ gridModeCellBuilder: SIBGridModeCellFactory)
    {
        self.gridModeCellBuilder = gridModeCellBuilder
    }
    
    //MARK: -
    //MARK: Appearance
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath)
    {
        if (self.gridModeTheme.responds(to: #selector(SIBGridModeAppearance.itemsBrowser(_:didHighlight:for:at:))))
        {
            guard let loadedLevel = self.loadedLevel else
            {
                return
            }
            
            let cell = self.collectionView.cellForItem(at: indexPath)
            let selectedItemIndex = indexPath.row
            let selectedItem = loadedLevel.levelContentItems[selectedItemIndex]
            
            self.gridModeTheme.itemsBrowser!(self, didHighlight: cell!, for: selectedItem, at: indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath)
    {
        if (self.gridModeTheme.responds(to: #selector(SIBGridModeAppearance.itemsBrowser(_:didUnhighlight:for:at:))))
        {
            guard let loadedLevel = self.loadedLevel else
            {
                return
            }
            
            let cell = self.collectionView.cellForItem(at: indexPath)
            let selectedItemIndex = indexPath.row
            let selectedItem = loadedLevel.levelContentItems[selectedItemIndex]
            
            self.gridModeTheme.itemsBrowser!(self, didUnhighlight: cell!, for: selectedItem, at: indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout
    {
        if (self.gridModeTheme.responds(to: #selector(SIBGridModeAppearance.itemsBrowser(_:transitionLayoutForOldLayout:toLayout:))))
        {
            return self.gridModeTheme.itemsBrowser!(self, transitionLayoutForOldLayout: fromLayout, toLayout: toLayout)
        }
        
        return UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
}

extension SCItemGridBrowser: UICollectionViewDataSource
{
    public func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let loadedLevel = self.loadedLevel else
        {
            return 0
        }
        
        return loadedLevel.itemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        assert(nil != loadedLevel, "Invalid parameter not satisfying: nil != loadedLevel")
        
        let cellIndex = indexPath.row
        let itemObject = self.loadedLevel!.levelContentItems[cellIndex]
        let isLevelUpItem: Bool = (type(of: itemObject) == SCLevelUpItem.self)
        
        if (isLevelUpItem)
        {
            return self.gridModeCellBuilder.itemsBrowser(self, createLevelUpCellAt: indexPath)
        }
        else
        {
            let cell: (UICollectionViewCell & SCItemCell) = self.gridModeCellBuilder.itemsBrowser(self, createGridModeCellFor: itemObject, at: indexPath)
            cell.setModel(item: itemObject)
            cell.reloadData()
            
            return cell
        }
    }
}

extension SCItemGridBrowser: UICollectionViewDelegate
{
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool
    {
        guard let loadedLevel = self.loadedLevel else
        {
            return false
        }
        
        let itemIndex = indexPath.row
        let itemObject = loadedLevel.levelContentItems[itemIndex]
        let isLevelUpItem: Bool = (type(of: itemObject) == SCLevelUpItem.self)
        
        if (isLevelUpItem)
        {
            return true
        }
        else
        {
            return self.delegate.itemsBrowser(self, shouldLoadLevelForItem: itemObject)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard let loadedLevel = self.loadedLevel else
        {
            return
        }
        
        let itemIndex = indexPath.row
        let itemObject = loadedLevel.levelContentItems[itemIndex]
        
        self.didSelectItem(itemObject, at: indexPath)
    }
}
