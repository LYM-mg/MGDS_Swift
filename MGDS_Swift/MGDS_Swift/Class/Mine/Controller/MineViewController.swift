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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = SaveTools.mg_UnArchiver(path: MGUserPath) as? User
        loginStatusLabel.text = (user != nil) ? "退出当前用户" : "立即登录"
        userHeaderView.user = user
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
                disclaimer()
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
        self.showHint(hint: "我的收藏")
    }

    // MARK: 第2️⃣页
    /// 给个笑脸,就是评价的意思
    fileprivate func giveFace() {
        let urlStr = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1044917946&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        guard let url = URL(string: urlStr) else { return }
        if UIApplication.shared.canOpenURL(url){
            let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
            UIApplication.shared.open(url, options: options, completionHandler: nil)
        }
    }
    /// 意见反馈
    fileprivate func giveSuggest() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    /// 免责声明
    fileprivate func  disclaimer() {
        self.showHint(hint: "免责声明")
    }
    
    // MARK: 第3️⃣页
    /// 关于逗视
    fileprivate func aboutDouShi(){
        let QRCodeVC = QRCodeViewController()
        show(QRCodeVC, sender: self)
    }
    
    /// 盆友需要
    fileprivate func shareToFriend() {
        let share = "https://itunes.apple.com/cn/app/id1044917946"
        UMSocialData.default().extConfig.title = "搞笑,恶搞视频全聚合,尽在逗视App"
        UMSocialWechatHandler.setWXAppId("wxfd23fac852a54c97", appSecret: "d4624c36b6795d1d99dcf0547af5443d", url: "\(share)")
        UMSocialQQHandler.setQQWithAppId("1104864621", appKey: "AQKpnMRxELiDWHwt", url: "\(share)")
        
        let snsArray = [UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToFacebook,UMShareToTwitter,UMShareToEmail]
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: "563b6bdc67e58e73ee002acd", shareText:"搞笑,恶搞视频全聚合,尽在逗视App   " + share, shareImage: UIImage(named: "doushi_icon"), shareToSnsNames: snsArray, delegate: nil)
    }
    
    // MARK: 第4️⃣页
    /// 关于登录
    func aboutLogin() {
        let user = SaveTools.mg_UnArchiver(path: MGUserPath) as? User
        if loginStatusLabel.text == "退出当前用户"{
            print("登录")
            //确定按钮
            let alertController = UIAlertController(title: "确定要退出吗？", message: "", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            }
            
            let OKAction = UIAlertAction(title: "确定", style: .default) { (action) in
                self.loginStatusLabel.text = "立即登录"
                self.loginStatusLabel.textColor = UIColor.green
            }
            alertController.addAction(cancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {
            }
        }else{
            
            /**
             跳转登录页面
             */
            print("立即登录")
            loginStatusLabel.text = "退出当前用户"
            loginStatusLabel.textColor = UIColor.red
            
            let loginVc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            self.navigationController?.pushViewController(loginVc!, animated: true)
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension MineViewController: MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        //设置收件人
        mailComposerVC.setToRecipients(["iosdev@itjh.com.cn"])
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
