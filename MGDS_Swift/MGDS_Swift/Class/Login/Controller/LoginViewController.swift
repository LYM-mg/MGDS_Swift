//
//  LoginViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

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
        let phoneRule = ValidationRuleLength(min: 3, max: 15, error: ValidationError(message: "😫"))
        let pwdRule = ValidationRuleLength(min: 3, max: 10, error:ValidationError(message: "😫"))

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
        
    }
    
    /**
     qq登录
     
     - parameter sender: 按钮
     */
    @IBAction func qqLogin(sender: UIButton) {
        
    }
    
    /**
     微博登录
     
     - parameter sender: 按钮
     */
    @IBAction func weiboLogin(sender: UIButton) {
        
    }
}
