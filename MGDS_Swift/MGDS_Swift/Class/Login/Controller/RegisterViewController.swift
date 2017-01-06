//
//  RegisterViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import Validator

class RegisterViewController: UIViewController {
    
    // MARK: - property
    @IBOutlet weak var headImageView: UIImageView!      // 头像
    @IBOutlet weak var resultUILabel: UILabel!          // 手机号状态显示
    @IBOutlet weak var pwdResultUILabel: UILabel!       // 密码状态显示
    @IBOutlet weak var phoneTextField: UITextField!     // 手机号
    @IBOutlet weak var code: UITextField!               // 验证码
    @IBOutlet weak var passwordTextField: UITextField!  // 密码
    @IBOutlet weak var registerBtn: UIButton!           // 注册按钮
    @IBOutlet weak var sendCodeBtn: UIButton!           // 发送验证码按钮
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.给头像添加点按手势
        headImageView.isUserInteractionEnabled = true
        headImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.uploadHeadImage(_:))))
        
        // 2.设置代理监听textField的变化
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(RegisterViewController.textFieldDidReChange(_:)), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(RegisterViewController.textFieldDidReChange(_:)), for: UIControlEvents.editingChanged)
        
        
        // 3.设置注册按钮一开始为不可点击
        registerBtn.isEnabled = false
        registerBtn.alpha = 0.6
        
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    /**
     检测正在输入
     
     - parameter textField: textField description
     */
    @objc fileprivate func textFieldDidReChange(_ textField: UITextField) {
        let phoneRule = ValidationRuleLength(min: 11, max: 11, error: ValidationError(message: "😫"))
        let pwdRule = ValidationRuleLength(min: 3, max: 15, error:ValidationError(message: "😫"))
        let result: ValidationResult
        
        switch textField.tag{
            case 1://手机号
                result = textField.text!.validate(rule: phoneRule)
                if result.isValid {
                    resultUILabel.text = "😀"
                }else{
                    resultUILabel.text = "😫"
                }
            case 2://密码
                result = textField.text!.validate(rule: pwdRule)
                if result.isValid {
                    pwdResultUILabel.text = "😀"
                    
                }else{
                    pwdResultUILabel.text = "😫"
                }
//            case 3: //验证码
//                print("验证码")
                
            default:
                break
        }
        
        // 判断状态OK 恢复注册按钮点击时间
        if (resultUILabel.text == "😀" &&  pwdResultUILabel.text == "😀") {
            registerBtn.isEnabled = true
            registerBtn.alpha = 1
        }
    }

}

// MARK: - Upload headImage
extension RegisterViewController {
    /**
     上传头像
     
     - parameter sender: 点按手势
     */
    func uploadHeadImage(_ tap: UITapGestureRecognizer) {
        
    }
}

// MARK: - Get verification code
extension RegisterViewController {
    /**
     获取验证码
     
     - parameter sender: 发送验证码按钮的点击
     */
    @IBAction func sendCodeBtnClick(_ sender: UIButton) {
        
    }
}


// MARK: - Register
extension RegisterViewController {
    /**
     注册
     
     - parameter sender: 注册按钮的点击
     */
    
    @IBAction func registerBtnClick(_ sender: UIButton) {
        
    }
}
