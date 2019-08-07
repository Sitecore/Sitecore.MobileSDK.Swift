
import Foundation

public class ScSessionBuilder
{
    public static func readOnlySession(_ url: String) -> IReadOnlySessionBuilder
    {
        return ReadOnlySessionBuilder(url)
    }
    
    public static func readWriteSession(_ url: String) -> IReadWriteSessionBuilder
    {
        return ReadWriteSessionBuilder(url)
    }
}
