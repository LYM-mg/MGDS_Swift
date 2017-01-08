//
//  LoginViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.

import UIKit
import  Validator

struct ValidationError: Error {
    
    public let message: String
    
    public init(message m: String) {
        message = m
    }
}

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var phoneResultUILabel: UILabel!
    @IBOutlet weak var pwdResultUILabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.delegate = self
        pwdTextField.delegate = self
        
        
        phoneTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidReChange(textField:)), for: UIControlEvents.editingChanged)
        pwdTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidReChange(textField:)), for: UIControlEvents.editingChanged)
        
        
        //设置登录按钮一开始为不可点击
        loginBtn.isEnabled = false
        loginBtn.alpha = 0.6
    }

}

// MARK: - 
extension LoginViewController: UITextFieldDelegate {
    /**
     检测正在输入
     
     - parameter textField: textField description
     */
    @objc fileprivate func textFieldDidReChange(textField: UITextField) {
        let phoneRule = ValidationRuleLength(min: 11, max: 11, error: ValidationError(message: "😫"))
        let pwdRule = ValidationRuleLength(min: 3, max: 15, error:ValidationError(message: "😫"))

        let result: ValidationResult
        
        switch textField.tag{
            case 1://手机号
                result = textField.text!.validate(rule: phoneRule)
                if result.isValid {
                    phoneResultUILabel.text = "😀"
                }else{
                    phoneResultUILabel.text = "😫"
                }
            case 2://密码
                result = textField.text!.validate(rule: pwdRule)
                if result.isValid {
                    pwdResultUILabel.text = "😀"
                }else{
                    pwdResultUILabel.text = "😫"
                }
            default:
                break
        }
        
        //        //判断状态OK 恢复登录按钮点击时间
        if (phoneResultUILabel.text == "😀" &&  pwdResultUILabel.text == "😀") {
            loginBtn.isEnabled = true
            loginBtn.alpha = 1
        }
    }
    
}

// MARK: - action
extension LoginViewController {
    // 登录按钮的点击
    @IBAction func loginBtnClick(_ sender: UIButton) {
//        NetWorkTools.defManager.request("https://api.ds.itjh.net/v1/rest/user/loginUser\(phone)/\(password)", method: .get, parameters: <#T##Parameters?#>)
    }
    
    /**
     qq登录
     
     - parameter sender: 按钮
     */
    @IBAction func qqLogin(sender: UIButton) {
        self.view.endEditing(true)
        loginWithSocialPlatform(name: UMShareToQQ, platformName: "QQ")
    }





    /**
     微博登录
 
     - parameter sender: 按钮
     */
    @IBAction func weiboLogin(sender: UIButton) {
         self.view.endEditing(true)
        loginWithSocialPlatform(name: UMShareToSina, platformName: "WeiBo")
    }
    
    /**
        第三方登录的方法
        - parameter name: 平台
        - parameter platformName: 平台名字
     */
    fileprivate func loginWithSocialPlatform(name: String,platformName: String) {
        //授权
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatform(withName: name)
        
        snsPlatform?.loginClickHandler(self, UMSocialControllerService.default(), true, {response in
            if response?.responseCode == UMSResponseCodeSuccess {
                
                guard var snsAccount = UMSocialAccountManager.socialAccountDictionary() else {return}
                
                let qqUser: UMSocialAccountEntity =  snsAccount[name] as! UMSocialAccountEntity
                print("微博用户数据\(qqUser)")
                
                let user = User()
                user.phone = ""
                user.password = ""
                user.gender = 1
                //用户id
                user.platformId = qqUser.usid
                user.platformName = platformName
                //微博昵称
                user.nickName = qqUser.userName
                //用户头像
                user.headImage = qqUser.iconURL
                UserDefaults.standard.setValue(qqUser.iconURL, forKey: "userHeadImage")
                SaveTools.mg_Archiver(user, path:  MGUserPath)
                //注册用户
                //用户参数
                let urlStr = "https://api.ds.itjh.net/v1/rest/user/registerUser"
                let parameters = ["nickName": user.nickName,"headImage": user.headImage,"phone":user.phone,"platformId":user.platformId,"platformName":user.platformName,"password":user.password,"gender":user.gender] as [String : Any]
                
                SysNetWorkTools.httpsRequest(url: urlStr, methodType: .post, parameters: parameters, successed: { (result, err) in
                    print(result)
                    }, failure: { (err) in
                        print(err)
                })
                
                NetWorkTools.registRequest(type: .post, urlString: urlStr, parameters: parameters, succeed: { (result, err) in
                    print(result)
                    }, failure: { (err) in
                        print(err)
                })
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
}
