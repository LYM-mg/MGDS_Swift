//
//  RegisterViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - 属性
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var resultUILabel: UILabel!
    @IBOutlet weak var pwdResultUILabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField! //手机号
    @IBOutlet weak var code: UITextField! //验证码
    @IBOutlet weak var passwordTextField: UITextField! //密码

    override func viewDidLoad() {
        super.viewDidLoad()

        headImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.uploadHeadImage(_:)))
        headImageView.addGestureRecognizer(tapGestureRecognizer)
    
    }
}

// MARK: - 用户选择头像
extension RegisterViewController {
    /**
     上传头像
     
     - parameter sender: 点按手势
     */
    func uploadHeadImage(_ tap: UITapGestureRecognizer) {
        
    }
}

// MARK: - 获取验证码
extension RegisterViewController {
    /**
     获取验证码
     
     - parameter sender: 发送验证码按钮的点击
     */
    @IBAction func sendCodeBtnClick(_ sender: UIButton) {
        
    }
}


// MARK: - 注册
extension RegisterViewController {
    /**
     注册
     
     - parameter sender: 注册按钮的点击
     */
    
    @IBAction func registerBtnClick(_ sender: UIButton) {
        
    }
}
