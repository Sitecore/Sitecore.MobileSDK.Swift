//
//  LoginResponse.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/29/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

class LoginResponse: ILoginResponse {
    required init(json: Data, source: IItemSource?) {
        
    }
    
    //TODO: @igk not implemented!!!
    func isSuccessful() -> Bool {
        return true
    }
    
}
