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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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
        self.showHudInViewWithMode(view: view, hint: "正在登陆", mode: .determinate, imageName: nil)
        
        AVUser.logInWithUsername(inBackground: self.phoneTextField.text, password: self.pwdTextField.text) { (user, error) -> Void in
            if error == nil {
                let user1 = User()
                user1.nickName = user!.username
                user1.password = user!.password
                SaveTools.mg_Archiver(user1, path:  MGUserPath)
                let _ = self.navigationController?.popViewController(animated: true)
            } else {
                let err = error as! NSError
                if err.code == 210 {
                    self.showHint(hint: "用户名或密码错误")
                }else if err.code == 211 {
                    self.showHint(hint: "不存在该用户")
                }else if err.code == 216 {
                    self.showHint(hint: "未验证邮箱")
                }else if err.code == 1{
                     self.showHint(hint: "操作频繁")
                }else{
                    self.showHint(hint: "登录失败")
                }
            }
            self.hideHud()
        }
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
                print("用户数据\(qqUser)")
                
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
                //                let urlStr = "https://api.ds.itjh.net/v1/rest/user/registerUser"
                //                let parameters = ["nickName": user.nickName,"headImage": user.headImage,"phone":user.phone,"platformId":user.platformId,"platformName":user.platformName,"password":user.password,"gender":user.gender] as [String : Any]
                
                //                NetWorkTools.registRequest(type: .post, urlString: urlStr, parameters: parameters, succeed: { (result, err) in
                //                    let userDict = (result as! NSDictionary).value(forKey: "content") as! [String: Any]
                //                    print(result)
                //                }, failure: { (err) in
                //                    print(err)
                //                })

                
                /// 注册用户
                let user1 = AVUser()
                user1.username = user.nickName
                user1.password = "123"
                
                user1.signUpInBackground { (successed, error) in
                    if successed {
                        self.showHint(hint: "登录成功")
                    }else {
                        let err = error as! NSError
                        if err.code == 125 {
                            self.showHint(hint: "邮箱不合法")
                        }else if err.code == 203 {
                            self.showHint(hint: "该邮箱已注册")
                        }else if err.code == 202 {
                            self.showHint(hint: "用户名已存在")
                        }else{
                            self.showHint(hint: "注册失败")
                        }
                    }
                }

            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let _ = self.navigationController?.popViewController(animated: true)
        })
    }
}
