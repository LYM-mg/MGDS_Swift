//
//  BaseNavigationController.swift
//  chart2
//
//  Created by i-Techsys.com on 16/12/7.
//  Copyright © 2016年 i-Techsys. All rights reserved.
// 83 179 163

import UIKit

// MARK: - 生命周期
class BaseNavigationController: UINavigationController {
    
    override class func initialize() {
        super.initialize()
        // 0.设置导航栏的颜色
        setUpNavAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.全局拖拽手势
        setUpGlobalPan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

// MARK: - 拦截控制器的push操作
extension BaseNavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0 {
            let popBtn = UIButton(imageName: "goback", title: "", target: self, action: #selector(BaseNavigationController.popClick(sender:)))
            
            // 设置popBtn的属性
            popBtn.mg_size = CGSize(width: 23, height: 30)
            popBtn.setTitleColor(UIColor.white, for: .normal)
            popBtn.setTitleColor(UIColor.colorWithCustom(r: 60, g: 60, b: 60), for: .highlighted)
            
            popBtn.contentHorizontalAlignment = .left
            popBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
            popBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
            popBtn.titleEdgeInsets  = UIEdgeInsetsMake(0, 0, 0, 0)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: popBtn)
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func popClick(sender: UIButton) {
        popViewController(animated: true)
    }
    
    // 回到栈顶控制器
    public func popToRootVC() {
        popToRootViewController(animated: true)
    }
}

// MARK: - 全局拖拽手势
extension BaseNavigationController {
    /// 全局拖拽手势
    fileprivate func setUpGlobalPan() {
        // 1.创建Pan手势
        let target = interactivePopGestureRecognizer?.delegate
        let globalPan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        globalPan.delegate = self
        self.view.addGestureRecognizer(globalPan)
        
        // 2.禁止系统的手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    /// 什么时候支持全屏手势
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.childViewControllers.count != 1
    }
}

// MARK: - 设置导航栏肤色
extension BaseNavigationController {
    fileprivate class func setUpNavAppearance() {
        // ======================  bar ======================
        var navBarAppearance = UINavigationBar.appearance()
        if #available(iOS 9.0, *) {
           navBarAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [BaseNavigationController.self as UIAppearanceContainer.Type])
        } 
        
        if #available(iOS 10.0, *) {  // 导航栏透明
            navBarAppearance.isTranslucent = true
        } else {
            self.init().navigationBar.isTranslucent = false
        }

        navBarAppearance.barTintColor = UIColor(r: 39, g: 105, b: 187)
        navBarAppearance.tintColor = UIColor.orange
        
        var titleTextAttributes = [String : Any]()
        titleTextAttributes[NSForegroundColorAttributeName] =  UIColor.orange
        titleTextAttributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 19)
        navBarAppearance.titleTextAttributes = titleTextAttributes
        
        // ======================  item  =======================
        let barItemAppearence = UIBarButtonItem.appearance()
        // 设置导航字体
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        var attributes = [String : Any]()
        attributes[NSForegroundColorAttributeName] = UIColor(r: 245.0, g: 245.0, b: 245.0)
        attributes[NSShadowAttributeName] = shadow
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 17)
        
        barItemAppearence.setTitleTextAttributes(attributes, for: .normal)
        
        attributes[NSForegroundColorAttributeName] = UIColor.yellow
        barItemAppearence.setTitleTextAttributes(attributes, for: .highlighted)
    }
}

