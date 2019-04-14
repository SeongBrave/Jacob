//
//  Product_model.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import SwiftyJSON
import ModelProtocol

class Product_model: ModelProtocol {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kProductImageurlKey: String = "imageurl"
    internal let kProductAttrKey: String = "attr"
    internal let kProductDescKey: String = "desc"
    internal let kProductInternalIdentifierKey: String = "id"
    internal let kProductCreatedAtKey: String = "createdAt"
    internal let kProductUpdatedAtKey: String = "updatedAt"
    internal let kProductPdnameKey: String = "pdname"
    internal let kProductUriKey: String = "uri"
    
    
    // MARK: 属性
    var imageurl: String
    var attr: String
    var desc: String
    var internalIdentifier: String
    var createdAt: Int
    var updatedAt: Int
    var pdname: String
    var uri: String
    
    
    // MARK: 实现MikerSwiftJSONAble 协议， 解析json数据
    public required  init?(json: JSON) {
        imageurl = json[kProductImageurlKey].stringValue
        attr = json[kProductAttrKey].stringValue
        desc = json[kProductDescKey].stringValue
        internalIdentifier = json[kProductInternalIdentifierKey].stringValue
        createdAt = json[kProductCreatedAtKey].intValue
        updatedAt = json[kProductUpdatedAtKey].intValue
        pdname = json[kProductPdnameKey].stringValue
        uri = json[kProductUriKey].stringValue
        
    }
    
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        
        dictionary.updateValue(imageurl as AnyObject, forKey: kProductImageurlKey)
        
        dictionary.updateValue(attr as AnyObject, forKey: kProductAttrKey)
        
        dictionary.updateValue(desc as AnyObject, forKey: kProductDescKey)
        
        dictionary.updateValue(internalIdentifier as AnyObject, forKey: kProductInternalIdentifierKey)
        
        dictionary.updateValue(createdAt as AnyObject, forKey: kProductCreatedAtKey)
        
        dictionary.updateValue(updatedAt as AnyObject, forKey: kProductUpdatedAtKey)
        
        dictionary.updateValue(pdname as AnyObject, forKey: kProductPdnameKey)
        
        dictionary.updateValue(uri as AnyObject, forKey: kProductUriKey)
        
        
        return dictionary
    }
    
    
}
