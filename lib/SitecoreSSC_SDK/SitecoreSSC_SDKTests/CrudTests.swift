
import XCTest
@testable import SitecoreSSC_SDK

class CrudTests: XCTestCase, URLSessionDelegate
{

    private let instanceUrl = "https://cms900.pd-test16-1-dk1.dk.sitecore.net"
    
    
    //configurated test instance required, anonymous user must have write permissions
//    private let credentials = SCCredentials(username: "admin", password: "b", domain: "Sitecore")
    
    
    private var urlSession: URLSession?
    private var sscSession: SSCSession?
    
    //"!!!IGNORING SSL!!!"
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate)
        {
            completionHandler(.rejectProtectionSpace, nil)
        }
        
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
    }
    
    override func setUp()
    {
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        sscSession = SSCSession(url: instanceUrl, urlSession: urlSession)
    }

    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateItem()
    {
        let createRequest = ScRequestBuilder.createItemByPathRequest("/sitecore/content/home")
                                            .database("master")
                                            .ItemName("New item name")
                                            .TemplateId("76036F5E-CBCE-46D1-AF0A-4143F9B557AA")
                                            .addFieldsToChange("new title", forKey: "Title")
                                            .addFieldsToChange("my text", forKey: "Text")
                                            .build()
                
        let expectation = XCTestExpectation(description: "CReating item")
        
        sscSession!.sendCreateItemRequest(createRequest) { result in
            
            switch result
            {
            case .success(let response):
                
                XCTAssertNotNil(response, "response must not be nil")
                XCTAssertNotNil(response!.createdItemId, "item Id must not be nil, response code: \(String(describing: response?.statusCode))")

                if let id = response?.createdItemId!.uuidString
                {
                    TestUtils.delete(item: id, database: "master", with: self.sscSession!)
                    {
                        expectation.fulfill()
                    }
                }
                
            case .failure(let err):
                //we will assert test here, if any
                XCTAssertNil(err, "error must be nil, but \(err)")
                expectation.fulfill()
            }

            
        }
        
        wait(for: [expectation], timeout: 100.0)

    }

    func testReadByIdItem()
    {
        let readRequest = ScRequestBuilder.getItemByIdRequest(StringTestData.homeItemUuidString)
                                          .build()
        
        let expectation = XCTestExpectation(description: "Read item")
        
        sscSession!.sendGetItemsRequest(readRequest) { result in
            
            switch result
            {
            case .success(let response):
                
                XCTAssertNotNil(response, "response must not be nil")
                
                let item = response?.items[0]
                XCTAssertNotNil(item, "response must not be nil")
                print("item display name: \(item?.displayName)")
                XCTAssertTrue(item?.displayName == "Home", "item name must be Home, but: \(String(describing: item?.displayName))")
                
            case .failure(let err):
                //we will assert test here, if any
                XCTAssertNil(err, "error must be nil, but \(err)")
                
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
        
    }
        
    func testReadByUUIDItem()
    {
        let id: UUID = UUID(uuidString: StringTestData.homeItemUuidString)!
        
        let readRequest = ScRequestBuilder.getItemByIdRequest(id)
            .build()
        
        let expectation = XCTestExpectation(description: "Read item")
        
        sscSession!.sendGetItemsRequest(readRequest) { result in
            
            switch result
            {
            case .success(let response):
                
                XCTAssertNotNil(response, "response must not be nil")
                
                let item = response?.items[0]
                XCTAssertNotNil(item, "response must not be nil")
                
                XCTAssertTrue(item?.displayName == "Home", "item name must be Home, but: \(String(describing: item?.displayName))")
                
            case .failure(let err):
                
                //we will assert test here, if any
                XCTAssertNil(err, "error must be nil, but \(err)")
                
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testReadChildren()
    {
        let id: UUID = UUID(uuidString: StringTestData.homeItemUuidString)!
        
        let readChildrenRequest = ScRequestBuilder.getChildrenByParentIdRequest(id)
            .build()
        
        let expectation = XCTestExpectation(description: "Read children")
        
        sscSession!.sendGetItemsRequest(readChildrenRequest) { result in
            
            switch result
            {
            case .success(let response):
                
                XCTAssertNotNil(response, "response must not be nil")
                XCTAssertTrue(response?.items.count == 6, "items count must be 6, but actually: \(String(describing: response?.items.count))")
                let item = response?.items[0]
                XCTAssertNotNil(item, "response must not be nil")
                
            case .failure(let err):
                //we will assert test here, if any
                XCTAssertNil(err, "error must be nil, but \(err)")
                
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testReadByIdWithUUIDItem()
    {
        let id = UUID(uuidString: StringTestData.homeItemUuidString)!
        let readRequest = ScRequestBuilder.getItemByIdRequest(id)
            .build()
        
        let expectation = XCTestExpectation(description: "Read item")
        
        sscSession!.sendGetItemsRequest(readRequest) { result in
            
            switch result
            {
            case .success(let response):
                
                XCTAssertNotNil(response, "response must not be nil")
                
                let item = response?.items[0]
                XCTAssertNotNil(item, "response must not be nil")
                
                XCTAssertTrue(item?.displayName == "Home", "item name must be Home, but actually: \(String(describing: item?.displayName))")
                
            case .failure(let err):
                
                //we will assert test here, if any
                XCTAssertNil(err, "error must be nil, but \(err)")
                expectation.fulfill()
                
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testReadByPathItem()
    {
        let readRequest = ScRequestBuilder.getItemByPathRequest("/sitecore/content/Home")
            .build()
        
        let expectation = XCTestExpectation(description: "Read item")
        
        sscSession!.sendGetItemsRequest(readRequest) { result in
            
            switch result
            {
            case .success(let response):
                
                XCTAssertNotNil(response, "response must not be nil")
                
                let item = response?.items[0]
                XCTAssertNotNil(item, "response must not be nil")
                
                XCTAssertTrue(item?.displayName == "Home", "item name must be Home, but: \(String(describing: item?.displayName))")
                
            case .failure(let err):
                
                //we will assert test here, if any
                XCTAssertNil(err, "error must be nil, but \(err)")
                expectation.fulfill()
                
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testEditItem()
    {
        let createRequest = ScRequestBuilder.createItemByPathRequest("/sitecore/content/home")
            .database("master")
            .ItemName("New item name")
            .TemplateId("76036F5E-CBCE-46D1-AF0A-4143F9B557AA")
            .addFieldsToChange("new title", forKey: "Title")
            .addFieldsToChange("my text", forKey: "Text")
            .build()
        
        let expectation = XCTestExpectation(description: "Creating item")
        
        
        sscSession!.sendCreateItemRequest(createRequest) { createResult in
            
            print("\n!!!CREATED!!!\n")

            
            switch createResult
            {
            case .success(let response):
                
                XCTAssertNotNil(response, "response must not be nil")
                XCTAssertNotNil(response!.createdItemId, "item Id must not be nil, response code: \(String(describing: response?.statusCode))")
                
                let createdId: UUID = response!.createdItemId!
                
                let editRequest = ScRequestBuilder.updateItemRequest(response!.createdItemId!)
                                                  .database("master")
                                                  .addFieldsToChange("blablabla", forKey: "Title")
                                                  .build()
                
                self.sscSession!.sendUpdateItemRequest(editRequest) { editResult in
                    
                    print("\n!!!CHANGED!!!\n")

                    switch editResult
                    {
                    case .success(let response):
                        
                        XCTAssertNotNil(response, "response must not be nil")
                        XCTAssertTrue(response?.statusCode == 204, "status code must be 204, but: \(String(describing: response?.statusCode))")
                        
                        let readRequest = ScRequestBuilder.getItemByIdRequest(createdId)
                                                          .database("master")
                                                          .build()
                        
                        self.sscSession!.sendGetItemsRequest(readRequest) { readResult in
                            
                            print("\n!!!READ!!!\n")
                            
                            switch readResult
                            {
                            case .success(let response):
                                
                                XCTAssertNotNil(response, "response must not be nil")
                                
                                let item = response?.items[0]
                                XCTAssertNotNil(item, "response must not be nil")
                                
                                XCTAssertTrue(item?.getField("Title") == "blablabla", "item name must be 'blablabla', but: \(String(describing: item?.fields["Title"]))")

                                if let session = self.sscSession, let id = item?.id.uuidString
                                {
                                    TestUtils.delete(item: id, database: "master", with: session)
                                    {
                                        print("\n!!!DELETED!!!\n")

                                        expectation.fulfill()
                                    }
                                }
                                
                            case .failure(let err):
                                
                                //we will assert test here, if any
                                XCTAssertNil(err, "error must be nil, but \(err)")
                                expectation.fulfill()

                            }
                        }
                        
                    
                    case .failure(let err):
                        
                        //we will assert test here, if any
                        XCTAssertNil(err, "error must be nil, but \(err)")
                        expectation.fulfill()
                        
                    }
                }

                
            case .failure(let err):
                
                //we will assert test here, if any
                XCTAssertNil(err, "error must be nil, but \(err)")
                expectation.fulfill()
                
            }
        }
        
        wait(for: [expectation], timeout: 100.0)
        
    }
    
    
    func testDeleteItem()
    {
        
        let createRequest = ScRequestBuilder.createItemByPathRequest("/sitecore/content/home")
                                            .database("master")
                                            .ItemName("New item name")
                                            .TemplateId("76036F5E-CBCE-46D1-AF0A-4143F9B557AA")
                                            .addFieldsToChange("new title", forKey: "Title")
                                            .addFieldsToChange("my text", forKey: "Text")
                                            .build()
        
        let expectation = XCTestExpectation(description: "Creating item")
        
        
        sscSession!.sendCreateItemRequest(createRequest) { createResult in
            
            switch createResult
            {
            case .success(let response):
                
                XCTAssertNotNil(response, "response must not be nil")
                XCTAssertNotNil(response!.createdItemId, "item Id must not be nil, response code: \(String(describing: response?.statusCode))")
                
                let createdId: UUID = response!.createdItemId!
                
                let deleteRequest = ScRequestBuilder.deleteItemRequest(createdId)
                    .database("master")
                    .build()
                
                self.sscSession!.sendDeleteItemRequest(deleteRequest) { deleteResult in
                    
                    switch deleteResult
                    {
                    case .success(let response):
                        
                        XCTAssertNotNil(response, "response must not be nil")
                        XCTAssertTrue(response?.statusCode == 204, "status code must be 204, but: \(String(describing: response?.statusCode))")
                        
                        let readRequest = ScRequestBuilder.getItemByIdRequest(createdId)
                                                          .database("master")
                                                          .build()
                        
                        self.sscSession!.sendGetItemsRequest(readRequest) { readResult in
                            
                            switch readResult
                            {
                            case .success(let response):
                                
                                XCTAssertNotNil(response, "response must not be nil")
                                XCTAssertTrue(response?.items.count == 0, "response must be empty")
                      
                                expectation.fulfill()
            
                            case .failure(let err):
                                
                                //we will assert test here, if any
                                XCTAssertNil(err, "error must be nil, but \(err)")
                                expectation.fulfill()
                                
                            }
                        }
                        
                        
                    case .failure(let err):
                        
                        //we will assert test here, if any
                        XCTAssertNil(err, "error must be nil, but \(err)")
                        expectation.fulfill()
                        
                    }
                }
                
                
            case .failure(let err):
                
                //we will assert test here, if any
                XCTAssertNil(err, "error must be nil, but \(err)")
                expectation.fulfill()
                
            }
        }
        
        wait(for: [expectation], timeout: 100.0)
        
    }
    
    
    func testGetImage()
    {
        let expectation = XCTestExpectation(description: "Download image")
        
        let getItemRequest = ScRequestBuilder.getItemByIdRequest("4F20B519-D565-4472-B018-91CB6103C667")
            .build()
        
        sscSession!.sendGetItemsRequest(getItemRequest) { result in
            
            switch result
            {
            case .success(let response):
                print("!!! GET ITEM BY ID !!! \(String(describing: response?.items[0].displayName))")
                
                let downloadImageRequest = ScRequestBuilder.downloadImageRequestFor(mediaItem: (response?.items[0])!)
                    .build()
                
                let handlers = DataDownloadingProcess(completionHandler: { (image) in
                    XCTAssertNil(image, "image must not be nil")
                }, errorHandler: { (error) in
                    XCTAssertNil(error, "error must be nil, but \(error)")
                }, cancelationHandler: {
                    XCTAssertTrue(false, "image downloading must not be canceled")
                })
                
                self.sscSession!.sendDownloadImageRequest(downloadImageRequest, completion: handlers)
                
            case .failure(let error):
                print("network error: \(error) ")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 100.0)
        
    }
    
    func testCancelImage()
    {
        let expectation = XCTestExpectation(description: "Cancel image")
        
        let getItemRequest = ScRequestBuilder.getItemByIdRequest("3B0C644C-A382-4DA2-BA55-CFE82C88C724")
            .build()
        
        sscSession!.sendGetItemsRequest(getItemRequest) { result in
            
            switch result
            {
            case .success(let response):
                print("!!! GET ITEM BY ID !!! \(String(describing: response?.items[0].displayName))")
                
                let downloadImageRequest = ScRequestBuilder.downloadImageRequestFor(mediaItem: (response?.items[0])!)
                    .build()
                
                let handlers = DataDownloadingProcess(completionHandler: { (image) in
                    XCTAssertNotNil(image, "image must not be nil")
                }, errorHandler: { (error) in
                    XCTAssertFalse(error.localizedDescription == "canceled", "error must be 'canceled'")
                }, cancelationHandler: {
                    expectation.fulfill()
                })
                
            let token = self.sscSession!.sendDownloadImageRequest(downloadImageRequest, completion: handlers)
            
            token?.cancel()
                
            case .failure(let error):
                print("network error: \(error) ")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 100.0)
        
    }
    
    func testSearch()
    {
        
        let expectation = XCTestExpectation(description: "Cancel image")

        
        let searchRequest = ScRequestBuilder.runStoredSearchItemRequest("3D9F0EE2-C2D7-47C3-BCF0-51C92EB5EB31")
            .pageNumber(0)
            .itemsPerPageCount(100)
            .build()
        
        sscSession!.sendSerchItemsRequest(searchRequest) { result in
            switch result
            {
            case .success(let response):
                
                XCTAssertNotNil(response, "response must not be nil")
                XCTAssertTrue(response?.items.count == 52, "items count must be 6, but actually: \(String(describing: response?.items.count))")
                let item = response?.items[0]
                XCTAssertNotNil(item, "response must not be nil")
                
            case .failure(let error):
                XCTAssertNil(error, "response must not be nil")

            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)

    }
    
}
