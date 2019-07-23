
import Foundation

public typealias DownloadCompletionHandler  = (_ image: UIImage)->()
public typealias DownloadCancelationHandler = ()->()
public typealias DownloadErrorHandler       = (_ error: Error)->()

public class DataDownloadingProcess: NSObject
{
    private(set) var downloadCompletionHandler:  DownloadCompletionHandler
    private(set) var downloadErrorHandler:       DownloadErrorHandler
    private(set) var downloadCancelationHandler: DownloadCancelationHandler
    
    public init(
                completionHandler:   @escaping DownloadCompletionHandler,
                errorHandler:        @escaping DownloadErrorHandler,
                cancelationHandler:  @escaping DownloadCancelationHandler
               )
    {
        self.downloadCompletionHandler = completionHandler
        self.downloadCancelationHandler = cancelationHandler
        self.downloadErrorHandler = errorHandler
    }
}

public class ScImageLoader
{
    private static let cache = NSCache<NSString, NSData>()
    
    //TODO: 1 @igk create persistence/memory cache for big/small images, we have "Width": "100", "Height": "100" in request.mediaItem: ISitecoreItem
    //TODO: 2 @igk imnplement progress
    
    @discardableResult
    static func getImageWithRequest(_ request: IGetImageRequest, session: URLSession, completion: DataDownloadingProcess) -> RequestToken?
    {
        guard let imagePath = request.buildUrlString(sessionConfig: request.sessionConfig!),
              let imageUrl = URL(string: imagePath)
        else
        {
            return nil
        }
        
        if let data = self.cache.object(forKey: imagePath as NSString)
        {
            ScImageLoader.convertDataToImage(data as Data, with: completion)
            return nil
        }
        
        let task = session.dataTask(with: imageUrl) { data, response, error in
            
            if let er = error
            {
                completion.downloadErrorHandler(SSCError.responseError(er))
                return
            }
            
            guard let data = data else
            {
                print("getImageWithRequest: data not received")
                completion.downloadErrorHandler(SSCError.runtimeError("status code: \(String(describing: response?.httpStatusCode))"))
                return
            }
            
            self.cache.setObject(data as NSData, forKey: imageUrl.absoluteString as NSString)
            
            self.convertDataToImage(data, with: completion)
        }
        
        task.resume()
        
        return RequestToken(task)
    }
    
    private static func convertDataToImage(_ data: Data, with completion: DataDownloadingProcess)
    {
        guard let image = UIImage(data: data as Data) else
        {
            completion.downloadErrorHandler(SSCError.runtimeError("ScImageLoader: data can not be converted to an image"))
            return
        }
    
        completion.downloadCompletionHandler(image)
    }
    
    public static func getImageWithRequest(_ request: IGetImageRequest, completion: DataDownloadingProcess) -> RequestToken?
    {
        let defaultSession = URLSession(configuration: .default)
        
        return self.getImageWithRequest(request, session: defaultSession, completion: completion)
    }
    
    @discardableResult
    public static func getImageWithRequest(_ item: ISitecoreItem, sessionConfig: ISessionConfig, completion: DataDownloadingProcess) -> RequestToken?
    {
        //@igk since sitecore's images is always available via http,
        // we can hack littlebit to avoid certificate issues while testing or etc...
        #warning("@igk should we remove this in release code!?!")
        let hackedurl = sessionConfig.instanceUrl.replacingOccurrences(of: "https:", with: "http:")
        let hackedSessionConfig = SessionConfig(url: hackedurl, requestSyntax: sessionConfig.requestSyntax)
        
        let imageRequest = GetImageRequest(mediaItem: item, sessionConfig: hackedSessionConfig)
        
        return self.getImageWithRequest(imageRequest, completion: completion)
    }

}
