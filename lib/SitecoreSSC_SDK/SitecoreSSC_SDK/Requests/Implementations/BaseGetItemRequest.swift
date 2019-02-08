//
//  BaseGetItemRequest.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 2/8/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

public class BaseGetItemRequest: IBaseGetItemsRequest
{
    public let ignoreCache: Bool
    
    public let itemSource: IItemSource?
    public let includeStandardTemplateFields: Bool
    public let sessionConfig: ISessionConfig?
    public var fields: [String]
    
    
    public init(
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        standardFields: Bool,
        ignoreCache: Bool = false
        )
    {
        //TODO: @igk check all input data
        self.itemSource = itemSource
        self.sessionConfig = sessionConfig
        self.includeStandardTemplateFields = standardFields
        self.ignoreCache = ignoreCache
        self.fields = []
    }
    
    public func buildUrlParametersString() -> String?
    {
        guard let sessionConfig = self.sessionConfig else
        {
            return nil
        }
        
        var parametersString = ""
        
        //fields list
        if (self.fields.count > 0)
        {
            let fieldsList = self.fields.joined(separator: ",")
            
            parametersString += self.compileParameter(name: sessionConfig.requestSyntax.FieldsListParameterName, value: fieldsList)
            
        }
        
        if let itemSource = self.itemSource
        {
            //item database
            if let dataBase = itemSource.database
            {
                parametersString += self.compileParameter(name: sessionConfig.requestSyntax.DatabaseParameterName, value: dataBase)
            }
            
            //item language
            if let language = itemSource.language
            {
                parametersString += self.compileParameter(name: sessionConfig.requestSyntax.LanguageParameterName, value: language)
            }
            
            //item version
            if let version: String = itemSource.versionNumber?.stringValue
            {
                parametersString += self.compileParameter(name: sessionConfig.requestSyntax.VersionParameterName, value: version)
            }
        }
        
        //includeStandardTemplateFields
        if ( self.includeStandardTemplateFields )
        {
            //"true" - just to be sure
            parametersString += self.compileParameter(name: sessionConfig.requestSyntax.IncludeStandardTemplateFieldsParameterName, value: "true")
        }
        
        if (parametersString.count == 0)
        {
            return nil
        }
        
        //remove extra delimeter
        parametersString.removeLast()
        
        return parametersString
    }
    
    internal func compileParameter(name: String, value: String) -> String
    {
        let result = name + sessionConfig!.requestSyntax.urlParmeterAssignSign + value + sessionConfig!.requestSyntax.urlParametersSeparator
        
        return result
    }
    
    public func buildUrlString() -> String?
    {
        return nil
    }
    
    public func addFieldToReturn(_ field: String)
    {
        self.fields.append(field)
    }
    
    public func buildHTTPRequest() -> URLRequest
    {
        //TODO: @igk check for errors
        var urlString = self.buildUrlString()!
        let parmeters = self.buildUrlParametersString()
        
        if (parmeters != nil)
        {
            urlString = urlString + sessionConfig!.requestSyntax.urlPathAndParametersSeparator
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


public class BasePaggedGetItemRequest: BaseGetItemRequest, IBaseGetPaggedItemsRequest
{
    public let pagingParameters: IPagingParameters?

    public init(
        pagingParameters: IPagingParameters?,
        itemSource: IItemSource?,
        sessionConfig: ISessionConfig?,
        standardFields: Bool
        )
    {
        self.pagingParameters = pagingParameters
        super.init(itemSource: itemSource, sessionConfig: sessionConfig, standardFields: standardFields)
    }
    
    public override func buildUrlParametersString() -> String?
    {
        let baseParameters = super.buildUrlParametersString()
        
        guard let pagingParameters = self.pagingParameters else {
            return baseParameters
        }
        
        var parameters = sessionConfig!.requestSyntax.ItemsPerPageParameterName
            + sessionConfig!.requestSyntax.urlParmeterAssignSign
            + String(pagingParameters.itemsPerPageCount)
            + sessionConfig!.requestSyntax.urlParametersSeparator
            + sessionConfig!.requestSyntax.PageNumberParameterName
            + sessionConfig!.requestSyntax.urlParmeterAssignSign
            + String(pagingParameters.pageNumber)
        
        if (baseParameters != nil )
        {
            parameters = baseParameters! + sessionConfig!.requestSyntax.urlParametersSeparator
                + parameters
        }
        
        return parameters
    }
}
