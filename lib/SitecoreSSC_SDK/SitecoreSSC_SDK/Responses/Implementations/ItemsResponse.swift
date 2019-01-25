//
//  ItemResponse.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/26/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

class ItemsResponse: IItemsResponse
{
    func isSuccessful() -> Bool {
        //TODO: @igk not implemented!!!
        return false
    }
    
    var items: [ISitecoreItem]
    
    required init(json: Data, source: IItemSource?, sessionConfig: ISessionConfig?) {
        
        var jsonString = String(data: json, encoding: .utf8)!
        print("\(jsonString)")
        
        //TODO: @igk refactor this!
        if (!jsonString.starts(with: "[")) {
            jsonString = "[\(jsonString)]"
        }
        
        do
        {
            let result = try (JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: []) as? Array<[String: Any]>)!
            
            self.items = result.map({ (elem) -> ISitecoreItem in
                return ScItem(fields: elem , source: source, sessionConfig: sessionConfig)
            })
            
        } catch {
            
            print(error.localizedDescription)
            self.items = [ISitecoreItem]()
            
        }
    }
 
}
