
import Foundation

public class RequestToken
{
    private weak var task: URLSessionDataTask?
    
    init(_ task: URLSessionDataTask)
    {
        self.task = task
    }
    
    func cancel()
    {
        guard let task = self.task else
        {
            return
        }
        
        task.cancel()
    }
}
