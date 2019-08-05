Sitecore Mobile SDK
========

Sitecore iOS Mobile SDK 1.0 for Sitecore Services Client (iOS SSC SDK) is a swift Library that provides the item manipulation API for iOS native client applications. 
The iOS SSC SDK serves as an interface that connects the Sitecore Services Client service and an application to let users work with items and fields rather than with HTTP requests and JSON responses.

The SDK includes the following features:

* Fetching CMS Content
* Create, Delete, Update Items
* Downloading Media Resources

# Licence
[SITECORE SHARED SOURCE LICENSE](https://github.com/Sitecore/Sitecore.MobileSDK.Swift/blob/master/license.txt)

## Code Snippet

Fetch the default "home" item content. 

```swift
let credentials = SCCredentials(username: "admin", password: "b", domain: "Sitecore")
 
sscSession = ScSessionBuilder.readWriteSeeeion("https://cms900.pd-test16-1-dk1.dk.sitecore.net")
    .customUrlSession(urlSession!)
    .credentials(credentials)
    .build()

let getItemRequest = ScRequestBuilder.getItemByIdRequest("11111111-1111-1111-1111-111111111111")
                                             .database("web")
                                             .language("en")
                                             .build()
  
sscSession.sendGetItemsRequest(getItemRequest) { result in
  
switch result
{
case .success(let response):
  
  print("\(String(describing: response?.items[0].displayName)))")
  self.endLoading()
  self.didLoadRootItem((response?.items[0])!)
  
case .failure(let error):
  print("network error: \(error) ")
}

}

```

# Links
- [Documentation]