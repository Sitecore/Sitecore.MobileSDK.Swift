//
//  ImageLoader.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 1/3/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

class ScImageLoader {
    
    private static let cache = NSCache<NSString, NSData>()
    
    
    //TODO: 1 @igk create persistence/memory cache for big/small images, we have "Width": "100", "Height": "100" in request.mediaItem: ISitecoreItem
    //TODO: 2 @igk impoment download task with progress
    
    static func getImageWithRequest(_ request: IGetImageRequest, session: URLSession, completion: @escaping(_ image: UIImage?, _ error: Error?) -> ()) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            let imagePath = request.buildUrl()
            
            if let data = self.cache.object(forKey: imagePath as NSString) {
                DispatchQueue.main.async { completion(UIImage(data: data as Data), nil) }
                return
            }
            
            let imageUrl = URL(string: imagePath)!
            
            let task = session.dataTask(with: imageUrl) { data, response, error in
                
                if (error != nil) {
                    completion(nil, SscError.networkError(error))
                    return
                }
                
                guard let data = data else {
                    print("something went wrong")
                    completion(nil, SscError.unknownNetworkError("status code: \(String(describing: response?.statusCode))"))
                    return
                }
                
                self.cache.setObject(data as NSData, forKey: imageUrl.absoluteString as NSString)
                
                DispatchQueue.main.async { completion(UIImage(data: data), nil) }
            }
            
            task.resume()
        }
    }
    
    static func getImageWithRequest(_ request: IGetImageRequest, completion: @escaping(_ image: UIImage?, _ error: Error?) -> ()) {
        
        let defaultSession = URLSession(configuration: .default)
        
        self.getImageWithRequest(request, session: defaultSession, completion: completion)
        
    }
    
}
