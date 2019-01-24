//
//  RequestToken.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 1/16/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

public class RequestToken {
    private weak var task: URLSessionDataTask?
    
    init(_ task: URLSessionDataTask) {
        self.task = task
    }
    
    func cancel() {
        task?.cancel()
    }
}
