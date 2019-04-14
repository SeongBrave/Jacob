//
//  Home_api.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import UtilCore
import Alamofire
import ModelProtocol
import NetWorkCore

public enum Home_api {

    ///列表
    case homes(page: Int, pageSize: Int)
    //add
    case addhome(param: [String: Any])
     //update
    case updatehome(id: String)
}

extension Home_api: TargetType {
    
    //商品数据
    public var path: String {
        switch self {
        case .homes:
            return "products"
        case .addhome:
            return "home/add"
        case .updatehome:
            return "home/update"
        }
    }
    
    //设置请求方式 get post等
    public var method: HTTPMethod {
        switch self {
        case .homes:
            return .get
        default :
            return .post
        }
    }

    /// 设置请求参数
    public var parameters: Parameters? {
        switch self {
        case let .homes(page, pageSize):
            return ["page": page, "pageSize": pageSize]
        case let .addhome(param):
            return param
        case let .updatehome(id):
            return ["id": id]
        }
    }
}
