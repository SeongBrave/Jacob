//
//  MainNavigatorMap.swift
//  Jacob_Example
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import URLNavigator
import UtilCore
import Jacob
import Carlisle
struct MainNavigatorMap {
    
    static func initialize(navigator: NavigatorType) {
        UtilCoreNavigatorMap.initialize(navigator: navigator)
        Jacob_router.initialize(navigator: navigator)
        Carlisle_router.initialize(navigator: navigator)
    }
}
