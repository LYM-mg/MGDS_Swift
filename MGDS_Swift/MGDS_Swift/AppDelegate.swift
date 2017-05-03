//
//  AppDelegate.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// http://c.m.163.com/nc/video/home/0-10.html

import UIKit
import IQKeyboardManagerSwift
import pop


//import Fabric
//import Answers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // MARK: - 自定义属性
    var reacha: Reachability? // 监听网络状态
    var preNetWorkStatus: NetworkStatuses? // 之前的网络状态
    var isFirstStart = true // 这里是第一次启动打开App的意思是用户完全退出运用然后打开，并不是指第一次安装打开
    
    lazy var videosArray: [VideoList] = [VideoList]()
    lazy var sidArray: [VideoSidList] = [VideoSidList]()
    
    // 引导页
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black
        return bgView
    }()
    fileprivate lazy var guardView: GuardScrollView = {
        let guardView = GuardScrollView(frame: UIScreen.main.bounds)
        guardView.backgroundColor = UIColor.white
        return guardView
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 1.主窗口
        setUpKeyWindow()
        
        // 2.加载数据
        loadData()
        
        // 3.键盘扩展
        IQKeyboardManager.sharedManager().enable = true
        
        // 4.友盟以、短信验证、以及激光推送等注册
        setUpUMSocial(launchOptions: launchOptions)
        
        // 5.实时检查网络状态
        checkNetworkStates()
        
        return true
    }

    deinit {
        print("AppDelegate--deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    // 首页腾讯数据
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
        if isFirstStart == true {
            let arr = ["login_video","loginmovie","qidong"]
            let welcomeVc = MGWelcomeViewController(urlStr: Bundle.main.path(forResource: arr[Int(arc4random()%3)], ofType: "mp4")!)
            window?.rootViewController = welcomeVc
            isFirstStart = false
        } else {
            let user = SaveTools.mg_UnArchiver(path: MGUserPath) as? User   // 获取用户数据
            window?.rootViewController =  (user == nil) ? UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() : MainTabBarViewController()
        }

        window?.makeKeyAndVisible()
        
        let isfirst = SaveTools.mg_getLocalData(key: "isFirstOpen") as? String
        if (isfirst?.isEmpty == nil) {
            UIApplication.shared.isStatusBarHidden = true
            showAppGurdView()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.EnterHomeView(_:)), name: NSNotification.Name(rawValue: KEnterHomeViewNotification), object: nil)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // 设置后台响应
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSessionCategoryPlayback)
        try? session.setActive(true)
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
    @available(iOS 9.0, *)
    @objc(application:performActionForShortcutItem:completionHandler:) func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        completionHandler(handledShortCutItem)
    }
    
    
    @available(iOS 9.0, *)
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        //Get type string from shortcutItem
        let user = SaveTools.mg_UnArchiver(path: MGUserPath) as? User   // 获取用户数据
        
        if shortcutItem.type == "2" {
            // 跳转
            window?.rootViewController =  (user == nil) ? UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() : MainTabBarViewController()
            
            handled = true
        }
        
        if user != nil {
            // 获取当前页面TabBar
            let tabBar = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
            // 获取当前TabBar Nav
            let nav = tabBar.selectedViewController as! UINavigationController
            
            if shortcutItem.type == "1" {
                tabBar.selectedIndex = 1
                handled = true
            }
            
            if shortcutItem.type == "3" {
                nav.pushViewController(QRCodeViewController(), animated: true)
                handled = true
            }
        }
        return handled
    }
}

// MARK: - 友盟以、短信验证、以及极光推送
extension AppDelegate {
    fileprivate func setUpUMSocial(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        // Share
        //        SMSSDK.registerApp("1a9f73be2f6ce", withSecret: "990c4bc75c8d27ba3fe88403ad722ff8")
        //  SMS 1a9fafc4d4a6c 8f8b196fb408ebe54b53c0b60ea0cf12
        SMSSDK.registerApp("1a9fafc4d4a6c", withSecret: "8f8b196fb408ebe54b53c0b60ea0cf12")
        
        // 友盟
        UMSocialData.setAppKey("58f6d91fbbea834d7200178b")
        UMSocialQQHandler.setQQWithAppId("1104864621", appKey: "AQKpnMRxELiDWHwt", url: "www.itjh.net")
        UMSocialQQHandler.setSupportWebView(true)
        /* 设置新浪的appKey和appSecret */
        UMSocialSinaHandler.openSSO(withRedirectURL: "https://github.com/LYM-mg/MGDS_Swift")
//        UMSocialSinaHandler.openSSO(withRedirectURL: "http://sns.whalecloud.com/sina2/callback")
        UMSocialWechatHandler.setWXAppId("wxfd23fac852a54c97", appSecret: "d4624c36b6795d1d99dcf0547af5443d", url: "www.doushi.me")

        
        /**
         设置LeanCloud
         */
//        AVOSCloud.setApplicationId("TA9p1dH9HIS1cDaVB8cu33eO-gzGzoHsz", clientKey: "M0Da93ljH6lN61H3iFGl5Nnr")
//        AVOSCloud.setApplicationId("i40Bw8oWkFemep2Rn2k9e5WX", clientKey: "MpeDsXwLTcQuuhplDjN1Hs8l")
        
        // 如果使用美国站点，请加上这行代码，并且写在初始化前面
//      LeanCloud.setServiceRegion(.US)
        // applicationId 即 App Id，applicationKey 是 App Key
        AVOSCloud.setApplicationId("Guvxe6EhKrfSTMPpiWC4LVMi-gzGzoHsz", clientKey: "nwy4pORkhij4Pg6hsNHdR1bU")
        
        
        // Required
//        APService.register(forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue , categories: nil)
//        // Required
//        APService.setup(withOption: launchOptions)
//        APService.setLogOFF()
    }
}

// MARK: - 网络状态检测
extension AppDelegate {
    fileprivate func checkNetworkStates() {
        MGNotificationCenter.addObserver(self, selector: #selector(AppDelegate.networkChange), name: NSNotification.Name.reachabilityChanged, object: nil)
        reacha = Reachability.init(hostName: "http://www.jianshu.com/collection/105dc167b43b")
        reacha?.startNotifier()
    }
    
    @objc fileprivate func networkChange() {
        var tips: NSString = ""
        guard let currentNetWorkStatus = NetWorkTools.getNetworkStates() else { return }
        if currentNetWorkStatus == preNetWorkStatus { return }
        preNetWorkStatus = currentNetWorkStatus
        switch currentNetWorkStatus {
        case .NetworkStatusNone:
            tips = "当前没有网络，请检查你的网络"
        case .NetworkStatus2G:
            tips = "当前是网速有点慢"
        case .NetworkStatus3G:
            tips = "当前是网速有点慢"
        case .NetworkStatus4G:
            tips = "切换到了4G模式，请注意你的流量"
        case .NetworkStatusWIFI:
            tips = ""
        }
        
        print(tips.lengthOfBytes(using: String.Encoding.utf16.rawValue))
        let length = tips.lengthOfBytes(using: String.Encoding.utf16.rawValue)
        if length > 0 {
            let alertView = UIAlertView(title: "明明科技", message: tips as String, delegate: nil, cancelButtonTitle: "好的")
            alertView.show()
            
        }
    }
}


// MARK: - 引导页
extension AppDelegate {
    fileprivate func showAppGurdView() {
        self.window!.addSubview(bgView)
        bgView.addSubview(guardView)
    }
    
    func EnterHomeView(_ noti: NSNotification) {
        // 获取通知传过来的按钮
        let dict = noti.userInfo as! [String : AnyObject]
        let btn = dict["sender"]
        
        SaveTools.mg_SaveToLocal(value: "false", key: "isFirstOpen")
        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) { 
            guard let showMenuAnimation = POPSpringAnimation(propertyNamed: kPOPViewAlpha) else {return}
            showMenuAnimation.toValue = (0.0)
            showMenuAnimation.springBounciness = 10.0
            btn!.pop_add(showMenuAnimation,forKey:"hideBtn")
            UIView.animate(withDuration: 1.5, animations: { () -> Void in
                self.bgView.layer.transform = CATransform3DMakeScale(2, 2, 2)
                self.bgView.alpha = 0
                },completion: { (completion) -> Void in
                    UIApplication.shared.isStatusBarHidden = false
                    self.bgView.removeFromSuperview()
            })
        }
    }
}

