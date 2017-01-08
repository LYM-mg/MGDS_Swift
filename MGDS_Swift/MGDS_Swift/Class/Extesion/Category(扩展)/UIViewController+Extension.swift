//
//  UIViewController+Extension.swift
//  chart2
//
//  Created by i-Techsys.com on 16/11/30.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit
import MBProgressHUD
import SnapKit

private let mainScreenW = UIScreen.main.bounds.size.width
private let mainScreenH = UIScreen.main.bounds.size.height

// MARK: - HUD
extension UIViewController {
    // MARK:- RuntimeKey   动态绑属性
    // 改进写法【推荐】
    struct RuntimeKey {
        static let mg_HUDKey = UnsafeRawPointer.init(bitPattern: "mg_HUDKey".hashValue)
        static let mg_GIFKey = UnsafeRawPointer(bitPattern: "mg_GIFKey".hashValue)
        static let mg_GIFWebView = UnsafeRawPointer(bitPattern: "mg_GIFWebView".hashValue)
        /// ...其他Key声明
    }
    
    // MARK:- HUD
    /**   =================================  HUD蒙版提示  ======================================  **/
    // 蒙版提示HUD
    var MBHUD: MBProgressHUD? {
        set {
            objc_setAssociatedObject(self, UIViewController.RuntimeKey.mg_HUDKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return  objc_getAssociatedObject(self, UIViewController.RuntimeKey.mg_HUDKey) as? MBProgressHUD
        }
    }
    
    /**
     *  提示信息
     *
     *  @param view 显示在哪个view
     *  @param hint 提示
     */
    func showHudInView(view: UIView, hint: String?, yOffset: Float = 0.0) {
        guard let hud = MBProgressHUD(view: view) else { return }
        hud.labelText = hint
        view.addSubview(hud)
        if yOffset != 0.0 {
            hud.margin = 10.0;
            hud.yOffset += yOffset;
        }
        hud.show(true)
        self.MBHUD = hud
    }
    
    /// 如果设置了图片名，mode的其他其他设置将失效
    func showHudInViewWithMode(view: UIView, hint: String?, mode: MBProgressHUDMode = .text, imageName: String?)  {
        guard let hud = MBProgressHUD(view: view) else { return }
        hud.labelText = hint
        view.addSubview(hud)

        hud.mode = mode
        if imageName != nil {
            hud.mode = .customView
            hud.customView = UIImageView(image: UIImage(named: imageName!))
        }
        
        hud.show(true)
        self.MBHUD = hud
    }

    
    /**
     *  隐藏HUD
     */
    func hideHud(){
        self.MBHUD?.hide(true)
    }

    
    /**
     *  提示信息 mode: MBProgressHUDModeText
     *
     *  @param hint 提示
     */
    func showHint(hint: String?, mode: MBProgressHUDMode = .text) {
        //显示提示信息
        guard let view = UIApplication.shared.delegate?.window else { return }
        guard let hud = MBProgressHUD.showAdded(to: view, animated: true)  else { return }
        hud.isUserInteractionEnabled = false
        hud.mode = MBProgressHUDMode.text
        hud.labelText = hint;
        hud.mode = mode
        hud.margin = 10.0;
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 2)
    }

    func showHint(hint: String?,mode: MBProgressHUDMode? = .text,view: UIView? = (UIApplication.shared.delegate?.window!)!, yOffset: Float = 0.0){
        //显示提示信息
        guard let hud = MBProgressHUD.showAdded(to: view, animated: true)  else { return }
        hud.isUserInteractionEnabled = false
        hud.mode = MBProgressHUDMode.text
        hud.labelText = hint

        if mode == .customView {
            hud.mode = .customView
            hud.customView = UIImageView(image: UIImage(named: "happy_face_icon"))
        }
        if mode != nil {
            hud.mode = mode!
        }
        hud.margin = 15.0
        if yOffset != 0.0 {
            hud.yOffset += yOffset;
        }

        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 2)
    }
    
    // 带图片的提示HUD，延时2秒消失
    func showHint(hint: String?,imageName: String?) {
        guard let hud = MBProgressHUD.showAdded(to: view, animated: true)  else { return }
        hud.isUserInteractionEnabled = false
        hud.mode = MBProgressHUDMode.text
        hud.labelText = hint
        
        if imageName != nil {
            hud.mode = .customView
            hud.customView = UIImageView(image: UIImage(named: imageName!))
        }else {
            hud.mode = .text
        }
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 2)
    }
    
    // MARK: - 显示Gif图片
    /**   ============================  UIImageView显示GIF加载动画  ===============================  **/
    // MARK: - UIImageView显示Gif加载状态
    /** 显示加载动画的UIImageView */
    var mg_gifView: UIImageView? {
        set {
            objc_setAssociatedObject(self, UIViewController.RuntimeKey.mg_GIFKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, UIViewController.RuntimeKey.mg_GIFKey) as? UIImageView
        }
    }
    
    
    /**
     *  显示GIF加载动画
     *
     *  @param images gif图片数组, 不传的话默认是自带的
     *  @param view   显示在哪个view上, 如果不传默认就是self.view
     */
    func mg_showGifLoding(_ images: [UIImage]?,size: CGSize? , inView view: UIView?) {
        var images = images
        if images == nil {
            images = [UIImage(named: "hold1_60x72")!,UIImage(named: "hold2_60x72")!,UIImage(named: "hold3_60x72")!]
        }
        
        var size = size
        if size == nil {
            size = CGSize(width: 60, height: 70)
        }
        
        let gifView = UIImageView()
        var view = view
        if view == nil {
            view = self.view
        }
        view?.addSubview(gifView)
        self.mg_gifView = gifView
        gifView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(size!)
        }
        
        gifView.playGifAnimation(images: images!)
    }
    
    /**
     *  取消GIF加载动画
     */
    func mg_hideGifLoding() {
        self.mg_gifView?.stopGifAnimation()
        self.mg_gifView = nil;
    }
    
    /**
     *  判断数组是否为空
     *
     *  @param array 数组
     *
     *  @return yes or no
     */
    func isNotEmptyArray(array: [Any]) -> Bool {
        if array.count >= 0 && !array.isEmpty{
            return true
        }else {
            return false
        }
    }

    
    
    /** ==============================  UIWebView显示GIF加载动画  =================================  **/
    // MARK: - UIWebView显示GIF加载动画
    /** UIWebView显示Gif加载状态 */
    weak var mg_GIFWebView: UIWebView? {
        set {
            objc_setAssociatedObject(self, UIViewController.RuntimeKey.mg_GIFWebView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIViewController.RuntimeKey.mg_GIFWebView) as? UIWebView
        }
    }
    
    /// 使用webView加载GIF图片
    /**
     *   如果view传了参数，移除的时候也要传同一个参数
     */
    func mg_showWebGifLoading(frame:CGRect?, gifName: String?,view: UIView?, filter: Bool? = false) {
        var gifName = gifName
        if gifName == nil || gifName == "" {
            gifName = "gif2"
        }
        
        var frame = frame
        if frame == CGRect.zero || frame == nil {
            frame = CGRect(x: 0, y: (self.navigationController != nil) ? MGNavHeight : CGFloat(0), width: mainScreenW, height: mainScreenH)
        }
        
        /// 得先提前创建webView,不能在子线程创建webView，不然程序会崩溃
        let webView = UIWebView(frame: frame!)
        // 子线程加载耗时操作加载GIF图片
        DispatchQueue.global().async {
            // 守卫校验
            guard let filePath = Bundle.main.path(forResource: gifName, ofType: "gif") else {
                return
            }
            guard let gifData: Data = NSData(contentsOfFile: filePath) as? Data else { return }
            if (frame?.size.height)! < mainScreenH - MGNavHeight {
                webView.center = CGPoint(x: (mainScreenW-webView.frame.size.width)/2, y: (mainScreenH-webView.frame.size.height)/2)
            }else {
                webView.center = self.view.center
            }
            webView.scalesPageToFit = true
            webView.load(gifData, mimeType: "image/gif", textEncodingName: "UTF-8", baseURL:  URL(fileURLWithPath: filePath))
            webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            webView.backgroundColor = UIColor.black
            webView.isOpaque = false
            webView.isUserInteractionEnabled = false
            webView.tag = 10000
            
            // 回到主线程将webView加到 UIApplication.shared.delegate?.window
            DispatchQueue.main.async {
                var view = view
                if view == nil { // 添加到窗口
                    view = (UIApplication.shared.delegate?.window)!
                }else {   // 添加到控制器
                    self.mg_GIFWebView = webView
                }
                view?.addSubview(webView)
                view?.bringSubview(toFront: webView)
                //创建一个灰色的蒙版，提升效果（ 可选 ）
                if filter! {  // true
                    let filter = UIView(frame: self.view.frame)
                    filter.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
                    webView.insertSubview(filter, at: 0)
                }
            }
        }
    }
    
    /**
     *  取消GIF加载动画，隐藏webView
     */
    func mg_hideWebGifLoding(view: UIView?) {
        if view == nil {  // 从窗口中移除
            guard let view = UIApplication.shared.delegate?.window else { return }
            guard let webView = view?.viewWithTag(10000) as? UIWebView else { return }
            webView.removeFromSuperview()
            webView.alpha = 0.0
        }else {  // 从控制器中移除
            self.mg_GIFWebView?.removeFromSuperview()
            self.mg_GIFWebView?.alpha = 0.0
        }
    }
}


    
