//
//  Product_api.swift
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

public enum Product_api{
    ///列表
    case products(page: Int, pageSize: Int)
    //add
    case addproduct(param: [String: Any])
    //update
    case updateproduct(id: String)
    
    
}
extension Product_api: TargetType {
    
    public var path: String {
        switch self {
        case .products:
            return "token/products"
        case .addproduct:
            return "product/add"
        case .updateproduct:
            return "product/update"
        }
    }
    
    //设置请求方式 get post等
    public var method: HTTPMethod {
        switch self {
        default :
            return .get
            
        }
    }
    
    /// 设置请求参数
    public var parameters: Parameters? {
        switch self {
        case let .products(page, pageSize):
            return ["page": page, "pageSize": pageSize]
        case let .addproduct(param):
            return param
        case let .updateproduct(id):
            return ["id": id]
        }
    }
    
}
