//
//  TestUtils.swift
//  SitecoreSSC_SDKTests
//
//  Created by Igor Khomich on 7/24/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation
@testable import SitecoreSSC_SDK

class TestUtils
{
    static func delete(item id: String, database: String, with session:SSCSession, completion: @escaping ()->())
    {
        let deleteRequest = ScRequestBuilder.deleteItemRequest(id)
            .database(database)
            .build()
        
        session.sendDeleteItemRequest(deleteRequest) { result in
            switch result
            {
            case .success(let response):
                print("!!! ItemDELETED !!! ID: \(id)")
                print("!!! DELETE STATUS CODE !!! ID: \(String(describing: response?.statusCode))")
            case .failure(let error):
                print("network error while deleting item: \(error), itemID: \(id)")
            }
            
            completion()
        }
    }
}
