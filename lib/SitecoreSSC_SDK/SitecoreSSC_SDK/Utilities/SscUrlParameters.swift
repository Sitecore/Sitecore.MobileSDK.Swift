//
//  SscUrlParameters.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/26/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

@objc public protocol ISscUrlParameters {
    
    var ItemSSCAuthEndpoint:                        String { get }
    var ItemSSCItemsEndpoint:                       String { get }
    var ItemSSCLoginAction :                        String { get }
    var ItemSSCLogoutAction:                        String { get }
    
    var DatabaseParameterName:                      String { get }
    var LanguageParameterName:                      String { get }
    var VersionParameterName:                       String { get }
    
    var SitecoreQueryParameterName:                 String { get }
    var ItemIdParameterName:                        String { get }
    var ItemPathParameterName:                      String { get }
    var ItemSSCChildrenAction:                      String { get }
    
    var RunStoredSearchAction:                      String { get }
    var RunStoredQueryAction:                       String { get }
    var ItemSearchAction:                           String { get }
    var SitecoreSearchParameterName:                String { get }
    var SortingParameterName:                       String { get }
    
    var RenderingIdParameterName:                   String { get }
    
    var TemplateParameterName:                      String { get }
    var FieldsListParameterName:                    String { get }
    var ItemNameParameterName:                      String { get }
    
    var ItemSSCEndpoint:                            String { get }
    var ItemSSCActionsEndpoint:                     String { get }
    
    var ItemSSCGetRenderingAction:                  String { get }
    
    var ItemSSCGetHashFormediaContentAction:        String { get }
    var UrlForHashingParameterName:                 String { get }
    
    var PageNumberParameterName:                    String { get }
    var ItemsPerPageParameterName:                  String { get }
    
    var IncludeStandardTemplateFieldsParameterName: String { get }
    
    //http syntax
    var urlPathSeparator:               String { get }
    var urlPathAndParametersSeparator:  String { get }
    var urlParametersSeparator:         String { get }
    var urlParmeterAssignSign:          String { get }
}


class ItemSSCV1UrlParameters: ISscUrlParameters
{
    init() {
        self.DatabaseParameterName = "database"
        self.LanguageParameterName = "language"
        self.VersionParameterName = "version"
        
        self.FieldsListParameterName = "fields"
        self.TemplateParameterName = "template"
        self.ItemNameParameterName = "name"
        self.SortingParameterName = "sorting"
        
        self.RenderingIdParameterName = "renderingId"
        
        self.ItemIdParameterName = "id"
        self.ItemPathParameterName = "path"
        
        self.SitecoreSearchParameterName = "term"
        
        self.SitecoreQueryParameterName = "query"
        
        self.ItemSSCEndpoint = "/sitecore/api/ssc"
        
        self.ItemSSCActionsEndpoint = "-/actions"
        
        self.ItemSSCItemsEndpoint = "/item"
        self.ItemSSCAuthEndpoint = "/auth"
        
        self.ItemSSCLoginAction = "/login"
        self.ItemSSCLogoutAction = "/logout"
        
        self.ItemSSCChildrenAction = "/children"
        self.ItemSearchAction = "/search"
        
        
        self.ItemSSCGetRenderingAction = "/getrenderinghtml"
        
        self.PageNumberParameterName = "page"
        self.ItemsPerPageParameterName = "pageSize"
        self.IncludeStandardTemplateFieldsParameterName = "includeStandardTemplateFields"
        
        self.ItemSSCGetHashFormediaContentAction = "/getsignedmediaurl"
        self.UrlForHashingParameterName = "url"
        
        self.RunStoredSearchAction = "/search"
        self.RunStoredQueryAction = "/query"
        
        
        //http syntax
        self.urlPathSeparator = "/"
        self.urlPathAndParametersSeparator = "?"
        self.urlParametersSeparator = "&"
        self.urlParmeterAssignSign = "="
        
    }
    
    public private(set) var ItemSSCAuthEndpoint:                        String
    public private(set) var ItemSSCItemsEndpoint:                       String
    public private(set) var ItemSSCLoginAction:                         String
    public private(set) var ItemSSCLogoutAction:                        String
    public private(set) var DatabaseParameterName:                      String
    public private(set) var LanguageParameterName:                      String
    public private(set) var VersionParameterName:                       String
    public private(set) var SitecoreQueryParameterName:                 String
    public private(set) var ItemIdParameterName:                        String
    public private(set) var ItemPathParameterName:                      String
    public private(set) var ItemSSCChildrenAction:                      String
    public private(set) var RunStoredSearchAction:                      String
    public private(set) var RunStoredQueryAction:                       String
    public private(set) var ItemSearchAction:                           String
    public private(set) var SitecoreSearchParameterName:                String
    public private(set) var SortingParameterName:                       String
    public private(set) var RenderingIdParameterName:                   String
    public private(set) var TemplateParameterName:                      String
    public private(set) var FieldsListParameterName:                    String
    public private(set) var ItemNameParameterName:                      String
    public private(set) var ItemSSCEndpoint:                            String
    public private(set) var ItemSSCActionsEndpoint:                     String
    public private(set) var ItemSSCGetRenderingAction:                  String
    public private(set) var ItemSSCGetHashFormediaContentAction:        String
    public private(set) var UrlForHashingParameterName:                 String
    public private(set) var PageNumberParameterName:                    String
    public private(set) var ItemsPerPageParameterName:                  String
    public private(set) var IncludeStandardTemplateFieldsParameterName: String
    
    
    //http syntax
    public private(set) var urlPathSeparator:               String
    public private(set) var urlPathAndParametersSeparator:  String
    public private(set) var urlParametersSeparator:         String
    public private(set) var urlParmeterAssignSign:          String
    
}
