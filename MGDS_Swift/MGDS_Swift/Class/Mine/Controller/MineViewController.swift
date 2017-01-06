//
//  MineViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MineViewController: UITableViewController {

    
    @IBOutlet weak var loginStatusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if indexPath.row == 0 {
                aboutLogin()
            }else {
                
            }
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
        
    }

    // MARK: 第2️⃣页
    /// 给个笑脸
    fileprivate func giveFace() {
        
    }
    /// 意见反馈
    fileprivate func giveSuggest() {
        
    }
    /// 免责声明
    fileprivate func  disclaimer() {
        
    }
    
    // MARK: 第3️⃣页
    /// 关于逗视
    fileprivate func aboutDouShi(){
        let QRCodeVC = QRCodeViewController()
        show(QRCodeVC, sender: self)
    }
    
    /// 盆友需要
    fileprivate func shareToFriend() {
        
    }
    
    // MARK: 第4️⃣页
    /// 关于登录
    func aboutLogin() {
        let user = UserDefaults.standard.object(forKey: "userInfo")
        
        if user != nil{
            print("登出")
            //确定按钮
            let alertController = UIAlertController(title: "确定要退出吗？", message: "", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            }
            
            let OKAction = UIAlertAction(title: "确定", style: .default) { (action) in
                self.loginStatusLabel.text = "立即登录"
                self.loginStatusLabel.textColor = UIColor.green
                UserDefaults.standard.removeObject(forKey: "userInfo")
            }
            alertController.addAction(cancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {
            }
        }else{
            
            /**
             跳转登录页面
             */
            print("登录")
            loginStatusLabel.text = "退出当前用户"
            loginStatusLabel.textColor = UIColor.red
            
            let loginVc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            self.navigationController?.pushViewController(loginVc!, animated: true)
        }
    }
}
