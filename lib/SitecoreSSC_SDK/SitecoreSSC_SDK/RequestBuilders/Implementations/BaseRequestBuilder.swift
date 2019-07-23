
import Foundation

    
public class BaseRequestBuilder<T: IScRequest>
{
    internal var database:       String?
    internal var language:       String?
    internal var versionNumber:  NSNumber?
    internal var sessionConfig: ISessionConfig?

    
    public func database(_ value: String) -> Self
    {
        if (self.database != nil) { fatalError("Database can not be set twice") }
        self.database = value
        
        return self
    }
    
    public func language(_ value: String) -> Self
    {
        if (self.language != nil) { fatalError("Language can not be set twice") }
        self.language = value
        
        return self
    }
    
    public func versionNumber(_ value: NSNumber) -> Self
    {
        if (self.versionNumber != nil) { fatalError("VersionNumber can not be set twice") }
        self.versionNumber = value
        
        return self
    }
    
    public func sessionConfig(_ value: ISessionConfig) -> Self
    {
        self.sessionConfig = value

        return self
    }
    
    public func build() -> T
    {
        fatalError("Must Override")
    }
}

public class BaseReadRequestBuilder<T: IBaseRequest>: BaseRequestBuilder<T>
{
    internal var includeStandardTemplateFields: Bool?
    internal var ignoreCache: Bool?
    internal var fields: [String] = []
    
    public func includeStandardTemplateFields(_ value: Bool) -> Self
    {
        if (self.includeStandardTemplateFields != nil) { fatalError("IncludeStandardTemplateFields can not be set twice") }
        self.includeStandardTemplateFields = value
        
        return self
    }
    
    public func ignoreCache(_ value: Bool) -> Self
    {
        if (self.ignoreCache != nil) { fatalError("IgnoreCache can not be set twice") }
        self.ignoreCache = value
        
        return self
    }
    
    public func addFieldsToRead(_ value: String) -> Self
    {
        if (self.fields.contains(value))
        {
            fatalError("Field name can not be duplicated")
        }
        
        self.fields.append(value)
        
        return self
    }
    
    
    public func addFieldsToRead(_ value: [String]) -> Self
    {
        value.forEach { elem in
            _ = self.addFieldsToRead(elem)
        }
        
        return self
    }
    
    //Compatibility
    
    public override func database(_ value: String) -> Self
    {
        _ = super.database(value)
        return self
    }
    
    public override func language(_ value: String) -> Self
    {
        _ = super.language(value)
        return self
    }
    
    public override func versionNumber(_ value: NSNumber) -> Self
    {
        _ = super.versionNumber(value)
        return self
    }
    
    public override func sessionConfig(_ value: ISessionConfig) -> Self
    {
        _ = super.sessionConfig(value)
        return self
    }
    
}

public class BasePaggedRequestBuilder<T: IBaseRequest>: BaseReadRequestBuilder<T>
{
    internal var itemsPerPageCount: Int?
    internal var pageNumber: Int?
    
    public func itemsPerPageCount(_ value: Int) -> Self
    {
        if (self.itemsPerPageCount != nil) { fatalError("ItemsPerPageCount can not be set twice") }
        self.itemsPerPageCount = value
        
        return self
    }
    
    public func pageNumber(_ value: Int) -> Self
    {
        if (self.pageNumber != nil) { fatalError("PageNumber can not be set twice") }
        self.pageNumber = value
        
        return self
    }
    
    //Compatibility
    
    public override func database(_ value: String) -> Self
    {
        _ = super.database(value)
        return self
    }
    
    public override func language(_ value: String) -> Self
    {
        _ = super.language(value)
        return self
    }
    
    public override func versionNumber(_ value: NSNumber) -> Self
    {
        _ = super.versionNumber(value)
        return self
    }
    
    public override func includeStandardTemplateFields(_ value: Bool) -> Self
    {
        _ = super.includeStandardTemplateFields(value)
        return self
    }
    
    public override func ignoreCache(_ value: Bool) -> Self
    {
        _ = super.ignoreCache(value)
        return self
    }
    
//    public override func sessionConfig(_ value: ISessionConfig) -> Self
//    {
//        _ = super.sessionConfig(value)
//        return self
//    }
    
    public override func addFieldsToRead(_ value: String) -> Self
    {
        _ = super.addFieldsToRead(value)
        return self
    }
    
    
    public override func addFieldsToRead(_ value: [String]) -> Self
    {
        _ = super.addFieldsToRead(value)
        return self
    }
}
