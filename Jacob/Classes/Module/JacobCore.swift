//
//  JacobCore.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation

/// 本模块的名称， 本模块的storyboard 名称必须 与模块名称相同 ,静态资源的加载回用到
let modularName = "Jacob"

public  class  JacobCore {
    
    public static var sharedInstance :  JacobCore {
        struct Static {
            static let instance :  JacobCore =  JacobCore()
        }
        return Static.instance
    }
    
    ///storyboard
    public static var storyboard:UIStoryboard {
        get {
            return UIStoryboard(name: modularName, bundle:  JacobCore.bundle)
        }
    }

    ///供主App调用使用 
    public static var home_vc:UIViewController {
        get {
            return   JacobCore.storyboard.instantiateViewController(withIdentifier: "Home_vc")
        }
    }
    
    public static var productVc:UIViewController {
        get {
            return   JacobCore.storyboard.instantiateViewController(withIdentifier: "Product_vc")
        }
    }
    
    ///供其他模块使用
    public static var bundle:Bundle? {
        get {
            guard let bundleURL = Bundle(for: JacobCore.self).url(forResource: modularName, withExtension: "bundle") else {
                return nil
            }
            guard let bundle = Bundle(url: bundleURL) else {
                return nil
            }
            return bundle
        }
    }
}
