
import Foundation
import SitecoreSSC_SDK

class SCLevelInfoPOD {

    let levelRequest: IBaseGetItemsRequest
    let levelParentItem: ISitecoreItem
    
    init(levelRequest: IBaseGetItemsRequest, item: ISitecoreItem) {
        self.levelRequest = levelRequest
        self.levelParentItem = item
    }
    
    
}

