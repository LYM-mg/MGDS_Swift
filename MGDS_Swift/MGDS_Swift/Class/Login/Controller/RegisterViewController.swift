//
//  RegisterViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import Validator
import MobileCoreServices

class RegisterViewController: UIViewController {
    
    // MARK: - property
    @IBOutlet weak var headImageView: UIImageView!      // 头像
    @IBOutlet weak var resultUILabel: UILabel!          // 手机号状态显示
    @IBOutlet weak var pwdResultUILabel: UILabel!       // 密码状态显示
    @IBOutlet weak var phoneTextField: UITextField!     // 手机号
    @IBOutlet weak var code: UITextField!               // 验证码
    @IBOutlet weak var passwordTextField: UITextField!  // 密码
    @IBOutlet weak var emailTextField: UITextField!     // 邮箱
    @IBOutlet weak var registerBtn: UIButton!           // 注册按钮
    @IBOutlet weak var sendCodeBtn: UIButton!           // 发送验证码按钮
    fileprivate var timer: Timer?
    fileprivate var remainingSeconds = 60 // 一分钟
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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
extension RegisterViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    /**
     上传头像
     
     - parameter sender: 点按手势
     */
    func uploadHeadImage(_ tap: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in }
        let OKAction = UIAlertAction(title: "拍照", style: .default) { (action) in
             self.openCamera(.camera)
        }
        let destroyAction = UIAlertAction(title: "从相册上传", style: .default) { (action) in
            print(action)
            self.openCamera(.photoLibrary)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
        alertController.addAction(destroyAction)
        
        // 判断是否为pad 弹出样式
        if let popPresenter = alertController.popoverPresentationController {
            popPresenter.sourceView = tap.view;
            popPresenter.sourceRect = (tap.view?.bounds)!
        }
        present(alertController, animated: true, completion: nil)
    }
    
    
    /**
     *  打开照相机/打开相册
     */
    func openCamera(_ type: UIImagePickerControllerSourceType,title: String? = "") {
        if !UIImagePickerController.isSourceTypeAvailable(type) {
            self.showInfo(info: "Camera不可用")
            return
        }
        let ipc = UIImagePickerController()
        ipc.sourceType = type
        ipc.allowsEditing = true
        ipc.delegate = self
        
        if title == "录像" {
            ipc.videoMaximumDuration = 60 * 3
            ipc.videoQuality = .type640x480
            ipc.mediaTypes = [(kUTTypeMovie as String)]
            // 可选，视频最长的录制时间，这里是20秒，默认为10分钟（600秒）
            ipc.videoMaximumDuration = 20
            // 可选，设置视频的质量，默认就是TypeMedium
//            ipc.videoQuality = UIImagePickerControllerQualityType.typeMedium
        }
        present(ipc, animated: true,  completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        //判读是否是视频还是图片
        if mediaType == kUTTypeMovie as String {
            let moviePath = info[UIImagePickerControllerMediaURL] as? URL
            //获取路径
            let moviePathString = moviePath!.relativePath
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePathString){
                UISaveVideoAtPathToSavedPhotosAlbum(moviePathString, nil, nil, nil)
            }
            print("视频")
        } else {
            print("图片")
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            headImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Get verification code
extension RegisterViewController {
    /**
     获取验证码
     
     - parameter sender: 发送验证码按钮的点击
     */
    @IBAction func sendCodeBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if phoneTextField.text?.lengthOfBytes(using: .utf8) != 11 {
            self.showHint(hint: "请输入11位手机号码")
            return
        }
        
        // 判断是否是正确的手机号!
        if !phoneTextField.text!.checkTelNumber() {
            self.showHint(hint: "请输入正确的11位手机号码")
            return
        }
        

        //    __block SMSGetCodeMethod method = SMSGetCodeMethodVoice;
        let alertVC = UIAlertController(title: "验证类型", message: nil, preferredStyle: .actionSheet)
        // 语音
        let speechAction = UIAlertAction(title: "语音", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.sendVerification(method: SMSGetCodeMethodVoice, phoneNumber: self.phoneTextField.text!)
        })
        // 短信
        let messageAction = UIAlertAction(title: "短信", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.sendVerification(method: SMSGetCodeMethodSMS, phoneNumber: self.phoneTextField.text!)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(speechAction)
        alertVC.addAction(messageAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    /**
       @from                    v1.1.1
       @brief                   获取验证码(Get verification code)
       - parameter method:            获取验证码的方法(The method of getting verificationCode)
       - parameter phoneNumber:       电话号码(The phone number)
       - parameter zone:              区域号，不要加"+"号(Area code)
       - parameter customIdentifier:  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
       - parameter result:            请求结果回调(Results of the request)
     */
    func sendVerification(method: SMSGetCodeMethod, phoneNumber: String) {
        weak var weakSelf = self
        // 必须要输入正确的手机号码才能来到下面的代码
        SMSSDK.getVerificationCode(by: method, phoneNumber: phoneNumber, zone: "86", customIdentifier: nil) { (err) -> Void in
            if err != nil { // 有错误
                weakSelf!.showHint(hint: "验证码发送失败")
                return
            }
            weakSelf!.sendCodeBtn.isUserInteractionEnabled = false
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RegisterViewController.updateTimer(_:)), userInfo: nil, repeats: true)
            weakSelf!.showHint(hint: "验证码发送成功")
        }
    }
    
    @objc fileprivate func updateTimer(_ timer: Timer) {
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
            self.remainingSeconds = 0
            self.timer!.invalidate()
            self.timer = nil
            sendCodeBtn.isEnabled = true
            sendCodeBtn.alpha = 1
            remainingSeconds = 60
        }
        sendCodeBtn.setTitle("\(remainingSeconds)s", for: .normal)
    }
}


// MARK: - Register
extension RegisterViewController {
    /**
     注册
     
     - parameter sender: 注册按钮的点击
     */
    @IBAction func registerBtnClick(_ sender: UIButton) {
        // 判断是否是正确的手机号!
        if !phoneTextField.text!.checkTelNumber() {
            self.showHint(hint: "请输入正确的11位手机号码")
            return
        }
        
        SMSSDK.commitVerificationCode(self.code.text!, phoneNumber: phoneTextField.text!, zone: "86") { (info, err) in
            if err == nil {
                print("验证成功")
            } else {
                self.showHint(hint: "错误信息:\(err)")
            }
        }
        
        // 注册成功后要恢复获取验证码按钮的可交互性  还有注册按钮
        sender.isUserInteractionEnabled = true
        sendCodeBtn.isUserInteractionEnabled = true
        sendCodeBtn.setTitle("获取验证码", for: .normal)
        remainingSeconds = 60
        timer?.invalidate()
        timer = nil;

        /// 注册用户
        let user = AVUser()
        user.username = phoneTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
    
        user.signUpInBackground { (successed, error) in
            if successed {
                self.showHint(hint: "注册成功，请验证邮箱")
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
}
