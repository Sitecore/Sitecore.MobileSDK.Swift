
import Foundation
import SitecoreSSC_SDK

typealias OnLevelLoadedBlock = (SCLevelResponse?, SSCError?) -> Void
typealias OnLevelProgressBlock = (Any?) -> Void

class SCItemsFileManagerCallbacks
{
    var onLevelLoadedBlock: OnLevelLoadedBlock
    var onLevelProgressBlock: OnLevelProgressBlock
    
    init(onLevelLoadedBlock: @escaping OnLevelLoadedBlock, onLevelProgressBlock: @escaping OnLevelProgressBlock) {
        self.onLevelLoadedBlock = onLevelLoadedBlock
        self.onLevelProgressBlock = onLevelProgressBlock
    }
}
