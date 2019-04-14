//
//  Home_model.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import SwiftyJSON
import ModelProtocol

class Home_model: ModelProtocol {

   // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let khomeCreatedAtKey: String = "createdAt"
    internal let khomeUpdatedAtKey: String = "updatedAt"
    internal let khomeIdKey: String = "id"
    internal let khomeDescKey: String = "desc"
    internal let khomePdnameKey: String = "pdname"
    internal let khomeAttrKey: String = "attr"
    internal let khomeUriKey: String = "uri"
    internal let khomeImageurlKey: String = "imageurl"

    // MARK: 属性

     var createdAt: Int
     var updatedAt: Int
     var homeid: String
     var desc: String
     var pdname: String
     var attr: String
     var uri: String
     var imageurl: String

    // MARK: 实现MikerSwiftJSONAble 协议， 解析json数据
    public required  init?(json: JSON) {

        createdAt  = json[khomeCreatedAtKey].intValue
        updatedAt  = json[khomeUpdatedAtKey].intValue
        homeid  = json[khomeIdKey].stringValue
        desc  = json[khomeDescKey].stringValue
        pdname  = json[khomePdnameKey].stringValue
        attr  = json[khomeAttrKey].stringValue
        uri  = json[khomeUriKey].stringValue
        imageurl  = json[khomeImageurlKey].stringValue

    }

}
