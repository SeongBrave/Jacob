//
//  Jacob_router.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import URLNavigator

public struct Jacob_router {
    
    public static func initialize(navigator: NavigatorType) {
        
     /// 跳转到商品列表 界面
        navigator.register("productvc".formatScheme()) { url, values ,context in
            let productVc:Product_vc = JacobCore.storyboard.instantiateViewController()
            return productVc
        }
        
        navigator.register("homevc".formatScheme()) { url, values ,context in
            let homeVc:Home_vc = JacobCore.storyboard.instantiateViewController()
            return homeVc
        }
 
    }
}
