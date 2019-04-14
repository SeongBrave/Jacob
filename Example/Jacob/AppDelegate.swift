//
//  AppDelegate.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import UIKit
import NetWorkCore
import UtilCore
import URLNavigator
import Jacob
import Bella
import Alice

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let navigator = Navigator()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setCommonAppleance()
        setupURLNavigator()
        setNetCoreConfing()
        setupRootViewController()
        // Override point for customization after application launch.
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
extension AppDelegate {
    /**
     设置导航等 的主题颜色
     */
    internal func setCommonAppleance(){
        
        UIApplication.shared.statusBarStyle = .lightContent
        let navigationBarAppearance = UINavigationBar.appearance()
        //设置显示的颜色
        navigationBarAppearance.barTintColor = UIColor.white
        navigationBarAppearance.tintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [kCTForegroundColorAttributeName:UIColor.black] as [NSAttributedString.Key : Any]
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barTintColor = UIColor.white
        tabBarAppearance.isOpaque = true
    }
    func setupURLNavigator(){
        MainNavigatorMap.initialize(navigator: navigator)
    }
    /// 修改NetWorkCore 网络相关配置
    func setNetCoreConfing() {
        Envs.baseUrl = ["http://seongbrave.cn/api/v1/"]
        Envs.isDebug = true
        NetWorkCore.baseUrl = Envs.baseUrl
        Global.shared.updateUserFromService()
        UtilCore.sharedInstance.toLoginErrorCode = 200010;
    }
    func setupRootViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds);
        self.window!.backgroundColor=UIColor.white;
        setTabBarVc()
    }
    func setTabBarVc() {
        let nav = UINavigationController(rootViewController: JacobCore.home_vc)
        let tabVc = UITabBarController()
        tabVc.viewControllers = [nav]
        self.window?.rootViewController = tabVc
    }
}

