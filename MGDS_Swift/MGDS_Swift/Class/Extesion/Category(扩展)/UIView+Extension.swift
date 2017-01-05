//
//  UIView+Extension.swift
//  chart2
//
//  Created by i-Techsys.com on 16/11/23.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit
// MARK: - 尺寸frame
extension UIView {
    /** origin的X */
    var mg_x: CGFloat! {
        get {
            return self.frame.origin.x
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newValue
            frame                 = tmpFrame
        }
    }
    
    /** origin的Y */
    var mg_y: CGFloat! {
        get {
            return self.frame.origin.y
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newValue
            frame                 = tmpFrame
        }
    }
    
    /** 中心点的X */
    var mg_center: CGPoint {
        get {
            return center
        }
        set {
            var tmpCenter : CGPoint = center
            tmpCenter               = newValue
            center                  = tmpCenter
        }
    }

    
    /** 中心点的X */
    var mg_centerX: CGFloat! {
        get {
            return self.center.x
        }
        set {
            var tmpCenter : CGPoint = center
            tmpCenter.x             = newValue
            center                  = tmpCenter
        }
    }
    
    /** 中心点的Y */
    var mg_centerY: CGFloat! {
        get {
            return self.center.y
        }
        set {
            var tmpCenter : CGPoint = center
            tmpCenter.y             = newValue
            center                  = tmpCenter
        }
    }
    
    /** 控件的宽度 */
    var mg_width: CGFloat! {
        get {
            return self.frame.size.width
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newValue
            frame                 = tmpFrame
        }
    }

    /** 控件的高度 */
    var mg_height: CGFloat! {
        get {
            return self.frame.size.height
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newValue
            frame                 = tmpFrame
        }
    }
    
    /** 控件的尺寸 */
    var mg_size: CGSize! {
        get {
            return self.frame.size
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.size         = newValue
            frame                 = tmpFrame
        }
    }
    
    /** 控件的origin */
    var mg_origin: CGPoint! {
        get {
        return self.frame.origin
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.origin       = newValue
            frame                 = tmpFrame
        }
    }
    
    var mg_rect: CGRect! {
        return self.frame
    }
    
    /// 圆角方法
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

// MARK: - 方法
extension UIView {
    /**
     - parameter cornerRadius: 半径
     */
    /// 给控件设置添加圆角
    func radiousLayer(cornerRadius: CGFloat)  -> CAShapeLayer{
        let maskPath = UIBezierPath(roundedRect: self.frame, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
//        let maskPath = UIBezierPath(roundedRect: self.frame, cornerRadius: cornerRadius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.frame;
        maskLayer.path = maskPath.cgPath
        return maskLayer
    }
    
    
    /**
     *  获取最后一个Window
     */
    func lastWindow() -> UIWindow {
        let windows = UIApplication.shared.windows as [UIWindow]
        for window in windows.reversed() {
            if window.isKind(of: UIWindow.self) && window.bounds.equalTo(UIScreen.main.bounds) {
                return window
            }
        }
        return UIApplication.shared.keyWindow!
    }
    
    /**
     *  自定义一个view的时候和父控制器隔了几层，需要刷新或者对父控制器做出一些列修改，
     *  这时候可以使用响应者连直接拿到父控制器，避免使用多重block嵌套或者通知这种情况
     */
    func topViewControllerTest() -> UIViewController? {
        var viewController: UIViewController?
        var next = self.superview
        while next != nil {
            let nextResponder: UIResponder = (next?.next)!
            if nextResponder.isKind(of: UIViewController.self) {
                viewController = nextResponder as? UIViewController
                break
            }
            next = next?.superview
        }
        return viewController
    }
    
    func topViewController()  -> UIViewController? {
        var viewController: UIViewController?
        var next = self.next
        while next != nil {
            if next!.isKind(of: UIViewController.classForCoder()) {
                viewController = next as? UIViewController
                break
            }
            next = next!.next
        }
        return viewController
    }
}

// MARK: - 查找一个视图的所有子视图
extension UIView {
    func allSubViewsForView(view: UIView) -> [UIView] {
        var array = [UIView]()
        for subView in view.subviews {
            array.append(subView)
            if (subView.subviews.count > 0) {
                // 递归
                let childView = self.allSubViewsForView(view: subView)
                array += childView
            }
        }
        return array
    }
}

// MARK: - 快速从XIB创建一个View (仅限于XIB中只有一个View的时候)
extension UIView {
    class func loadViewFromXib() -> UIView {
        return Bundle.main.loadNibNamed(NSStringFromClass(self.classForCoder()), owner: nil, options: nil)?.last! as! UIView
    }
}
// MARK: - 版本判断
// _url	NSURL	"app-settings:"	0x7bafc010
//        if #available(iOS 10.0, *) { // UIApplicationOpenURLOptionsKey
//            guard let url = URL(string: UIApplicationOpenSettingsURLString)  else {  return  }
//            if  UIApplication.shared.canOpenURL(url) {
//                let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
//                UIApplication.shared.open(url, options: options, completionHandler: nil)
//            }
//        }

//        if NSFoundationVersionNumber >= NSFoundationVersionNumber10_0 {
//            guard let url = URL(string: UIApplicationOpenSettingsURLString)  else {  return  }
//            if  UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.openURL(url)
//                UserDefaults.standard.set("isPushToSystem", forKey: "isPushToSystem")
//                UserDefaults.standard.synchronize()
//            }
//        }else {
//            guard let url = URL(string: "prefs:root=WIFI") else {  return  }
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.openURL(url)
//            }
//        }
//
//if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)) {
//    // 代码块
//}
