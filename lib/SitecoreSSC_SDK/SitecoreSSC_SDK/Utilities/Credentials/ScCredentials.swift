//
//  ScCredentials.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/29/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

//TODO: @IGK WE NEED SECURED STORAGE HERE!!!
public protocol IScCredentials {
    var username: String { get }
    var password: String { get }
    var domain: String { get }
}

public class ScCredentials: IScCredentials {
    
    public init (username: String, password: String, domain: String)
    {
        self.username = username
        self.password = password
        self.domain = domain
        
    }
    
    public let username: String
    public let password: String
    public let domain: String

}
