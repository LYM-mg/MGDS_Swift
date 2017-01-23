//
//  AppDelegate.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// http://c.m.163.com/nc/video/home/0-10.html

import UIKit
import IQKeyboardManagerSwift


//import Fabric
//import Answers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var videosArray: [VideoList] = [VideoList]()
    lazy var sidArray: [VideoSidList] = [VideoSidList]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 1.主窗口
        setUpKeyWindow()
        
        // 2.加载数据
        loadData()
        
        // 3.键盘扩展
        IQKeyboardManager.sharedManager().enable = true
        
        // 4.友盟以、短信验证、以及激光推送
        setUpUMSocial(launchOptions: launchOptions)
        
        return true
    }

    // 腾讯数据
    fileprivate func loadData() {
        NetWorkTools.requestData(type: .get, urlString: "http://c.m.163.com/nc/video/home/0-10.html", succeed: {[unowned self] (result, err) in
            guard let result      = result as? [String: Any] else { return }
            guard let resultVideo = result["videoList"] as? [[String: Any]]  else { return }
            guard let resultSid   = result["videoSidList"] as? [[String: Any]]  else { return }
            
            for videoDict in resultVideo {
                let video = VideoList(dict: videoDict)
                self.videosArray.append(video)
            }

            // 加载头标题
            for sidDict in resultSid {
                let sid = VideoSidList(dict: sidDict)
                self.sidArray.append(sid)
            }
        }) { (err) in
            self.showInfo(info: "请求失败")
        }

    }
    
    fileprivate func setUpKeyWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarViewController()
        window?.makeKeyAndVisible()
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

// MARK: - 3D touch 
extension AppDelegate {
    /**
     3D Touch 跳转
     
     - parameter application:       application
     - parameter shortcutItem:      item
     - parameter completionHandler: handler
     */
    @objc(application:performActionForShortcutItem:completionHandler:) func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        completionHandler(handledShortCutItem)
    }
    
    
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        //Get type string from shortcutItem
        // 获取当前页面TabBar
        let tabBar = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        
        // 获取当前TabBar Nav
        let nav = tabBar.selectedViewController as! UINavigationController
        
        if shortcutItem.type == "1" {
            let homeVC = HomeViewController()
            
            homeVC.title = "首页"
            
            handled = true
        }
        
        if shortcutItem.type == "2" {
            
            // Find视图
            let storyMy = UIStoryboard(name: "Login", bundle: nil)
            
            // 排行榜列表页
            let loginView = storyMy.instantiateInitialViewController() as! LoginViewController
            loginView.title = "登录"
            // 跳转
            nav.pushViewController(loginView, animated: true)
            
            handled = true
        }
        return handled
    }
}

// MARK: - 友盟以、短信验证、以及激光推送
extension AppDelegate {
    fileprivate func setUpUMSocial(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        // Share
        //        SMSSDK.registerApp("1a9f73be2f6ce", withSecret: "990c4bc75c8d27ba3fe88403ad722ff8")
        //  SMS 1a9fafc4d4a6c 8f8b196fb408ebe54b53c0b60ea0cf12
        SMSSDK.registerApp("1a9fafc4d4a6c", withSecret: "8f8b196fb408ebe54b53c0b60ea0cf12")
        
        // 友盟
        UMSocialData.setAppKey("563b6bdc67e58e73ee002acd")
        
        UMSocialQQHandler.setQQWithAppId("1104864621", appKey: "AQKpnMRxELiDWHwt", url: "www.itjh.net")
        UMSocialQQHandler.setSupportWebView(true)
        UMSocialSinaHandler.openSSO(withRedirectURL: "http://sns.whalecloud.com/sina2/callback")
        UMSocialWechatHandler.setWXAppId("wxfd23fac852a54c97", appSecret: "d4624c36b6795d1d99dcf0547af5443d", url: "www.doushi.me")

        
        // Required
//        APService.register(forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue , categories: nil)
//        // Required
//        APService.setup(withOption: launchOptions)
//        APService.setLogOFF()
    }
}

