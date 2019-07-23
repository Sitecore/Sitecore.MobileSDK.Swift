
import Foundation
import SitecoreSSC_SDK

class SCLevelsHistory {
    
    var levelStorage: Array<SCLevelInfoPOD>
    
    init() {
        self.levelStorage = Array()
    }
    
    func pushRequest(_ request: IBaseGetItemsRequest, for item: ISitecoreItem)
    {
        let record = SCLevelInfoPOD(levelRequest: request, item: item)
        self.levelStorage.append(record)
    }
    
    func popRequest()
    {
        self.levelStorage.removeLast()
    }
    
    var currentLevel: Int {
        return self.levelStorage.count
    }
    
    var isRootLevelLoaded: Bool {
        return self.currentLevel >= 1
    }
    
    var isLevelUpAvailable: Bool {
        return self.currentLevel >= 2
    }
    
    var lastRequest: IBaseGetItemsRequest {
        return (self.levelStorage.last?.levelRequest)!
    }
    
    var lastItem: ISitecoreItem {
        return (self.levelStorage.last?.levelParentItem)!
    }
    
    var levelUpRecord: SCLevelInfoPOD? {
        if (!isLevelUpAvailable){
            return nil
        }
        
        let levelCount = self.currentLevel
        let index = levelCount - 2
        
        return self.levelStorage[index]
    }
    
    var levelUpRequest: IBaseGetItemsRequest? {
        return self.levelUpRecord?.levelRequest
    }
    
    var levelUpParentItem: ISitecoreItem? {
        return self.levelUpRecord?.levelParentItem
    }
    
}
