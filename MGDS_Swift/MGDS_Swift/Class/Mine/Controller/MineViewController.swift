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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     跳转登录页面
     */
    func toLoginView(){
        let loginVc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(loginVc!, animated: true)
        
        print("点击了登录")
    }

}


// MARK: - 代理
extension MineViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 3 && (indexPath as NSIndexPath).row == 0 {
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
//                    DataCenter.shareDataCenter.user = User()
//                    self.setHeadImage()
                    
                }
                alertController.addAction(cancelAction)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true) {
                }
            }else{
                print("登录")
                loginStatusLabel.text = "退出当前用户"
                loginStatusLabel.textColor = UIColor.red
            
                toLoginView()
            }
        }
    }
}
