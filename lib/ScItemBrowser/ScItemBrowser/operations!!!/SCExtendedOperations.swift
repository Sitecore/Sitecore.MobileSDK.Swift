//
//  SCExtendedOperations.swift
//  ScItemBrowser
//
//  Created by IGK on 12/6/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

protocol SCUploadProgress {
    var progress: NSNumber { get }
    var url: URL { get }
    var headers: Dictionary<String, Any> { get }
}

typealias SCAsyncOperationProgressHandler = (SCUploadProgress?) -> Void
typealias SCDidFinishAsyncOperationHandler = (Any?, Error?) -> Void
typealias SCCancelAsyncOperation = (Bool) -> Void
typealias SCCancelAsyncOperationHandler = SCCancelAsyncOperation
typealias SCExtendedAsyncOp = (SCAsyncOperationProgressHandler, SCCancelAsyncOperationHandler, SCDidFinishAsyncOperationHandler) -> SCCancelAsyncOperation
typealias SCExtendedOpChainUnit = (Any?) -> SCExtendedAsyncOp
