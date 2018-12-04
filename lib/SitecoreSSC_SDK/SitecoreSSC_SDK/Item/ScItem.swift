//
//  ScItem.swift
//  SitecoreSSC_SDK
//
//  Created by IGK on 11/23/18.
//  Copyright © 2018 Igor. All rights reserved.
//

import Foundation

public class ScItem: ISitecoreItem {
    
    public var source: IItemSource?
    
    public var displayName: String
    {
        get{
            return self.fields["DisplayName"]! as! String
        }
    }
    public var hasChildren: Bool
    {
        get{
            return NSString(string: self.fields["HasChildren"]! as! String).boolValue
        }
    }
    public var id: String
    {
        get{
            return self.fields["ItemID"]! as! String
        }
    }
    public var path: String
    {
        get{
            return self.fields["ItemPath"]! as! String
        }
    }
    public var templateId: String
    {
        get{
            return self.fields["TemplateID"]! as! String
        }
    }
    public var fieldsCount: Int
    {
        get{
            return self.fields.count
        }
    }
    
    
    public let fields: [String : Any]
    
    init (fields: [String : Any], source: IItemSource?)
    {
        self.fields = fields
        self.source = source
    }
    
}

public protocol ISitecoreItem {
    
    var source:         IItemSource? { get }
    var displayName:    String      { get }
    var hasChildren:    Bool        { get }
    var id:             String      { get }
    var path:           String      { get }
    var templateId:     String      { get }
    var fieldsCount:    Int         { get }
    
    var fields:         [String: Any]   { get }
    
}






