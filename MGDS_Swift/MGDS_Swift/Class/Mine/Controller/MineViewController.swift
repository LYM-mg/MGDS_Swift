//
//  MineViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MineViewController: UITableViewController {

    
    @IBOutlet weak var loginStatusLabel: UILabel!       // 登录状态
    @IBOutlet weak var userHeaderView: UserHeaderView!  // 用户头部信息View
    override func viewDidLoad() {
        super.viewDidLoad()
//        let blurEccect = UIBlurEffect(style: .light)
//        let effectView = UIVisualEffectView(effect: blurEccect)
//        effectView.frame = tableView.frame
//        view.addSubview(effectView)
        
//        let blurEffect = UIBlurEffect(style: .light)
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
//        self.tableView.separatorEffect = vibrancyEffect
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = SaveTools.mg_UnArchiver(path: MGUserPath) as? User
        if (user != nil){
           userHeaderView.user = user
        }
    }
}


// MARK: - 代理
extension MineViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            myFavourite()
            break
        case 1:
            if indexPath.row == 0 {
                giveFace()
            }else if indexPath.row == 1 {
                giveSuggest()
            } else {
                setUpWiFi()
            }
        case 2:
            if indexPath.row == 0 {
                aboutDouShi()
            }else {
                shareToFriend()
            }
        case 3:
            aboutLogin()
        default:
            break
        }
    }
}

// MARK: - 方法封装
extension MineViewController {
    // MARK: 第1️⃣页
    /// 我的收藏
    fileprivate func myFavourite() {
        self.tabBarController?.selectedIndex = 2
    }

    // MARK: 第2️⃣页
    /// 给个笑脸,就是评价的意思
    fileprivate func giveFace() {  // itms-apps://
        let urlStr = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appid)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        guard let url = URL(string: urlStr) else { return }
        if UIApplication.shared.canOpenURL(url){
             UIApplication.shared.openURL(url)
//            if #available(iOS 10.0, *) {
//                let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
//                UIApplication.shared.open(url, options: options, completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
        }
    }
    /// 意见反馈
    fileprivate func giveSuggest() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    /// 设置WIFi
    fileprivate func  setUpWiFi() {
        guard let url = URL(string: "app-Prefs:root=WIFI") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: 第3️⃣页
    /// 关于逗视
    fileprivate func aboutDouShi(){
        let QRCodeVC = QRCodeViewController()
        show(QRCodeVC, sender: self)
    }
    
    /// 盆友需要
    fileprivate func shareToFriend() {
        //  https://itunes.apple.com/cn/app/id1044917946
        let share = "https://github.com/LYM-mg"
        UMSocialData.default().extConfig.title = "搞笑,恶搞视频全聚合,尽在逗视App"
        UMSocialWechatHandler.setWXAppId("wxfd23fac852a54c97", appSecret: "d4624c36b6795d1d99dcf0547af5443d", url: "\(share)")
        UMSocialQQHandler.setQQWithAppId("1104864621", appKey: "AQKpnMRxELiDWHwt", url: "\(share)")
        UMSocialSinaHandler.openSSO(withRedirectURL: "https://github.com/LYM-mg/MGDS_Swift")
    UMSocialConfig.setFollowWeiboUids([UMShareToSina:"2778589865",UMShareToTencent:"@liuyuanming6388"]) // 563b6bdc67e58e73ee002acd
        let snsArray = [UMShareToWechatTimeline,UMShareToWechatSession,UMShareToTencent,UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToFacebook,UMShareToEmail]
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: "58f6d91fbbea834d7200178b", shareText:"搞笑,恶搞视频全聚合,尽在逗视App   " + share, shareImage: UIImage(named: "doushi_icon"), shareToSnsNames: snsArray, delegate: nil)
    }
    
    // MARK: 第4️⃣页
    /// 关于登录
    func aboutLogin() {
        //确定按钮
        let alertController = UIAlertController(title: "确定要退出吗？", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        
        let OKAction = UIAlertAction(title: "确定", style: .default) { (action) in
            self.loginStatusLabel.textColor = UIColor.green
            //删除归档文件
            let defaultManager = FileManager.default
            if defaultManager.isDeletableFile(atPath: MGUserPath) {
                try! defaultManager.removeItem(atPath: MGUserPath)
            }

            MGNotificationCenter.post(name: NSNotification.Name(KChange3DTouchNotification), object: nil)
            MGKeyWindow?.rootViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            let transAnimation = CATransition()
            transAnimation.type = kCATransitionPush
            transAnimation.subtype = kCATransitionFromLeft
            transAnimation.duration = 0.5
            MGKeyWindow?.layer.add(transAnimation, forKey: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension MineViewController: MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        //设置收件人
        mailComposerVC.setToRecipients(["lym.mgming@gmail.com","1292043630@qq.com"])
        //设置主题
        mailComposerVC.setSubject("逗视意见反馈")
        //邮件内容
        let info: [String: Any] = Bundle.main.infoDictionary!
        let appName = info["CFBundleName"] as! String
        let appVersion = info["CFBundleShortVersionString"] as! String
        mailComposerVC.setMessageBody("</br></br></br></br></br>基本信息：</br></br>\(appName)  \(appVersion)</br> \(UIDevice.current.name)</br>iOS \(UIDevice.current.systemVersion)", isHTML: true)
        return mailComposerVC
    }
   
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
