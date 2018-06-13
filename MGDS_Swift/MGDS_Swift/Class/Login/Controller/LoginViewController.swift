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
        self.title = "登录"
        phoneTextField.delegate = self
        pwdTextField.delegate = self
        
        
        phoneTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidReChange(textField:)), for: UIControlEvents.editingChanged)
        pwdTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidReChange(textField:)), for: UIControlEvents.editingChanged)
        
        //设置登录按钮一开始为不可点击
        loginBtn.isEnabled = false
        loginBtn.alpha = 0.6
        
        textFieldDidReChange(textField: phoneTextField)
        textFieldDidReChange(textField: pwdTextField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

// MARK: -  UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    /**
     检测正在输入
     
     - parameter textField: textField description
     */
    @objc fileprivate func textFieldDidReChange(textField: UITextField) {
        let phoneRule = ValidationRuleLength(min: 2, max: 21, error: ValidationError(message: "😫"))
        let pwdRule = ValidationRuleLength(min: 3, max: 15, error:ValidationError(message: "😫"))

        let result: ValidationResult
        switch textField.tag{
            case 1://手机号
                result = textField.text!.validate(rule: phoneRule)
                phoneResultUILabel.text = result.isValid ? "😀" : "😫"
            case 2://密码
                result = textField.text!.validate(rule: pwdRule)
                pwdResultUILabel.text = result.isValid ? "😀" : "😫"
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
                let iconArr = ["https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2950591917,2354666181&fm=117&gp=0.jpg",
                               "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=785610095,2402278722&fm=117&gp=0.jpg",
                               "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2523342981,456767842&fm=117&gp=0.jpg",
                               "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2414892350,1335458424&fm=117&gp=0.jpg",
                               "http://img4.imgtn.bdimg.com/it/u=3150227654,1407185070&fm=23&gp=0.jpg",
                               "http://img1.imgtn.bdimg.com/it/u=4229711263,3512784892&fm=23&gp=0.jpg",
                               "http://img2.imgtn.bdimg.com/it/u=1600397295,882101291&fm=23&gp=0.jpg",
                               "http://img1.imgtn.bdimg.com/it/u=2724666881,1693626036&fm=23&gp=0.jpg",
                               "http://img0.imgtn.bdimg.com/it/u=845085609,3840359293&fm=23&gp=0.jpg",
                               "http://img4.imgtn.bdimg.com/it/u=1405137322,3395236384&fm=23&gp=0.jpg",
                               "http://img1.imgtn.bdimg.com/it/u=4088129600,4034692539&fm=23&gp=0.jpg",
                               "http://image.baidu.com/search/detail?ct=503316480&z=&tn=baiduimagedetail&ipn=d&word=%E5%A4%B4%E5%83%8F&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=-1&cs=1887792679,709769868&os=1882039900,1253656006&simid=4271764292,655119390&pn=14&rn=1&di=153173665370&ln=3968&fr=&fmq=1390280702008_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&is=0,0&istype=2&ist=&jit=&bdtype=0&spn=0&pi=0&gsm=0&oriquery=%E5%A4%B4%E5%83%8F&objurl=http%3A%2F%2Fwww.zbjdyw.com%2Fqqwebhimgs%2Fuploads%2Fbd24351977.jpg&rpstart=0&rpnum=0&adpicid=0"]
                user1.nickName = user!.username
                user1.password = user!.password
                user1.headImage = iconArr[Int(arc4random_uniform(13))]
                SaveTools.mg_Archiver(user1, path:  MGUserPath)
                self.turnToMainTabBarViewController()
            } else {
                let err = error! as NSError
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
    UMSocialConfig.setFollowWeiboUids([UMShareToSina:"2778589865",UMShareToTencent:"@liuyuanming6388"])
        
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
                self.turnToMainTabBarViewController()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    fileprivate func turnToMainTabBarViewController() {
        MGNotificationCenter.post(name: NSNotification.Name(KChange3DTouchNotification), object: nil)
        MGKeyWindow?.rootViewController = MainTabBarViewController()
        let transition = CATransition()
        transition.type = "reveal"
        transition.duration = 1.5
        MGKeyWindow?.layer.add(transition, forKey: nil)
    }
}
