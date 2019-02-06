//
//  CredentialsStorage.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 2/6/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation


class CredentialsStorage
{
    
    let service = "sitecore.services.client.storage"
    
    func updatePassword(_ password: String, for account: String)
    {
        KeychainStorage.removePassword(service: service, account: account)
        KeychainStorage.savePassword(service: service, account: account, data: password)
    }
    
    func removePassword(for account: String)
    {
        KeychainStorage.removePassword(service: service, account: account)
    }
    
    func setPassword(_ password: String, for account: String)
    {
        KeychainStorage.savePassword(service: service, account: account, data: password)
    }
    
    func getPassword(for account: String) -> String?
    {
        if let str = KeychainStorage.loadPassword(service: service, account: account)
        {
           return str
        }
    
        return nil
    }
    
}
