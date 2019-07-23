
import Foundation

public class BaseGetItemRequest: IBaseGetItemsRequest
{
    public let ignoreCache: Bool
    
    public let itemSource: IItemSource?
    public internal(set) var includeStandardTemplateFields: Bool = false
    public let sessionConfig: ISessionConfig?
    public internal(set) var fields: [String]
    
    
    public init(
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        standardFields: Bool?,
        fields: [String]?,
        ignoreCache: Bool = false
        )
    {
        //TODO: @igk check all input data
        self.itemSource = itemSource
        self.sessionConfig = sessionConfig
        if (standardFields != nil)
        {
            self.includeStandardTemplateFields = standardFields!
        }
       
        self.ignoreCache = ignoreCache
        
        if (fields != nil)
        {
            self.fields = fields!
        }
        else
        {
            self.fields = []

        }
    }
    
    public func buildUrlParametersString(sessionConfig: ISessionConfig) -> String?
    {
        return self.buildCommonParametersString(sessionConfig: sessionConfig)
    }
    
    public func buildCommonParametersString(sessionConfig: ISessionConfig) -> String?
    {
        var parametersString = ""
        
        //fields list
        if (self.fields.count > 0)
        {
            let fieldsList = self.fields.joined(separator: ",")
            
            parametersString += self.compileParameter(name: sessionConfig.requestSyntax.FieldsListParameterName, value: fieldsList, syntax: sessionConfig.requestSyntax)
            
        }
        
        if let itemSource = self.itemSource
        {
            //item database
            if let dataBase = itemSource.database
            {
                parametersString += self.compileParameter(name: sessionConfig.requestSyntax.DatabaseParameterName, value: dataBase, syntax: sessionConfig.requestSyntax)
            }
            
            //item language
            if let language = itemSource.language
            {
                parametersString += self.compileParameter(name: sessionConfig.requestSyntax.LanguageParameterName, value: language, syntax: sessionConfig.requestSyntax)
            }
            
            //item version
            if let version: String = itemSource.versionNumber?.stringValue
            {
                parametersString += self.compileParameter(name: sessionConfig.requestSyntax.VersionParameterName, value: version, syntax: sessionConfig.requestSyntax)
            }
        }
        
        //includeStandardTemplateFields
        if ( self.includeStandardTemplateFields )
        {
            //"true" - just to be sure
            parametersString += self.compileParameter(name: sessionConfig.requestSyntax.IncludeStandardTemplateFieldsParameterName, value: "true", syntax: sessionConfig.requestSyntax)
        }
        
        if (parametersString.count == 0)
        {
            return nil
        }
        
        //remove extra delimeter
        parametersString.removeLast()
        
        return parametersString
    }
    
    internal func compileParameter(name: String, value: String, syntax: ISSCUrlParameters) -> String
    {
        let result = name + syntax.urlParmeterAssignSign + value + syntax.urlParametersSeparator
        
        return result
    }
    
    public func buildUrlString(sessionConfig: ISessionConfig) -> String?
    {
        return nil
    }
    
    public func addFieldToReturn(_ field: String)
    {
        self.fields.append(field)
    }
    
    public func buildHTTPRequest() -> URLRequest
    {
        #warning("@IGK refactor this fatal error")
        guard let sessionConfig = self.sessionConfig else
        {
            fatalError("sessionConfig must not be nil to create HTTP request")
        }
        
        //TODO: @igk check for errors
        var urlString = self.buildUrlString(sessionConfig: sessionConfig)!
        let parmeters = self.buildUrlParametersString(sessionConfig: sessionConfig)
        
        if (parmeters != nil)
        {
            urlString = urlString + sessionConfig.requestSyntax.urlPathAndParametersSeparator
                + parmeters!
        }
        
        print("REQUEST URL: \(urlString)")
        
        var request = URLRequest(url: URL(string: urlString)!)
        
        if (self.ignoreCache)
        {
            request.cachePolicy = .reloadIgnoringLocalCacheData
        }
        else
        {
            request.cachePolicy = .returnCacheDataElseLoad
        }
        
        return request
    }
    
}

public class BasePaggedGetItemRequest: BaseGetItemRequest, IBaseGetPaginatedItemsRequest
{
    public let pagingParameters: IPagingParameters?

    public init(
        pagingParameters: IPagingParameters?,
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        fields: [String]?,
        standardFields: Bool
        )
    {
        self.pagingParameters = pagingParameters
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, standardFields: standardFields, fields: fields)
    }
    
    public override func buildUrlParametersString(sessionConfig: ISessionConfig) -> String?
    {
        
        let baseParameters = super.buildUrlParametersString(sessionConfig: sessionConfig)
        
        guard let pagingParameters = self.pagingParameters else
        {
            return baseParameters
        }
        
        var parameters = sessionConfig.requestSyntax.ItemsPerPageParameterName
            + sessionConfig.requestSyntax.urlParmeterAssignSign
            + String(pagingParameters.itemsPerPageCount)
            + sessionConfig.requestSyntax.urlParametersSeparator
            + sessionConfig.requestSyntax.PageNumberParameterName
            + sessionConfig.requestSyntax.urlParmeterAssignSign
            + String(pagingParameters.pageNumber)
        
        if (baseParameters != nil && !baseParameters!.isEmpty)
        {
            parameters = baseParameters! + sessionConfig.requestSyntax.urlParametersSeparator
                + parameters
        }
        
        return parameters
    }
}
