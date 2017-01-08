//
//  AppDelegate.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

//import Fabric
//import Answers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarViewController()
        window?.makeKeyAndVisible()
        
        
        //键盘扩展
        IQKeyboardManager.sharedManager().enable = true
        
        setUpUMSocial(launchOptions: launchOptions)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: - 友盟
extension AppDelegate {
    fileprivate func setUpUMSocial(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        // 友盟
        UMSocialData.setAppKey("563b6bdc67e58e73ee002acd")
        
        UMSocialQQHandler.setQQWithAppId("1104864621", appKey: "AQKpnMRxELiDWHwt", url: "www.itjh.net")
        
        UMSocialQQHandler.setSupportWebView(true)
        
        UMSocialSinaHandler.openSSO(withRedirectURL: "http://sns.whalecloud.com/sina2/callback")
        
        UMSocialWechatHandler.setWXAppId("wxfd23fac852a54c97", appSecret: "d4624c36b6795d1d99dcf0547af5443d", url: "www.doushi.me")
        

        //Share SMS
        SMSSDK.registerApp("c06e0d3b9ec2", withSecret: "ad02d765bad19681273e61a5c570a145")
        
        
        
        // Required
//        APService.register(forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue , categories: nil)
//        // Required
//        APService.setup(withOption: launchOptions)
//        APService.setLogOFF()
    }
}

