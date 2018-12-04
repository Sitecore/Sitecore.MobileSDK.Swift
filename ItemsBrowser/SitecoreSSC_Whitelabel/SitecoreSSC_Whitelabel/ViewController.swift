//
//  ViewController.swift
//  SitecoreSSC_Whitelabel
//
//  Created by IGK on 11/16/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import UIKit
import SitecoreSSC_SDK

class ViewController: UIViewController, URLSessionDelegate {


    var sscSession: SscSession?
    var urlSession: URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        sscSession = SscSession(url: "https://tst90170928.test24dk1.dk.sitecore.net", urlSession: urlSession!)
        
        let credentials = ScCredentials(username: "admin", password: "b", domain: "Sitecore")
        let itemSource = ItemSource(database: "web", language: "en  ")
        
        let loginRequest = LoginRequest(credentils: credentials)
        
        self.sscSession!.sendLoginRequest(request: loginRequest) { (response, error) in
            print("\(String(describing: response))")
            
            
            let getItemRequest = GetByIdRequest(
                itemId: "110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9",
                itemSource: itemSource,
                sessionConfig: nil,
                queryParameters: nil,
                standardFields: false
            )

            self.sscSession!.sendGetItemsRequest(request: getItemRequest) { (response, error) in
                print("\(response?.items[0].displayName))")
            }
            
            
            let getChildren = GetChildrenRequest(
                parentId: "110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9",
                pagingParameters: nil,
                itemSource: itemSource,
                sessionConfig: nil,
                queryParameters: nil,
                standardFields:false
            )
            
            self.sscSession!.sendGetItemsRequest(request: getChildren) { (response, error) in
                print("GET CHILDREN, COUNT: \(response?.items.count)")
                print("\(response?.items[0].displayName))")
            }
            
        }
        
       
    }

    
    #warning ("!!!IGNORING SSL VERIFICATION!!!")
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
            completionHandler(.rejectProtectionSpace, nil)
        }
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
    }

}


