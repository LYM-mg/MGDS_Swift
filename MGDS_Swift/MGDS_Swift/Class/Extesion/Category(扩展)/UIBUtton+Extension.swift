//
//  UIBUtton+Extension.swift
//  chart2
//
//  Created by i-Techsys.com on 16/12/7.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

extension UIButton {
    /// 遍历构造函数
    convenience init(imageName:String, bgImageName:String){
        self.init()
        
        // 1.设置按钮的属性
        // 1.1图片
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        
        // 1.2背景
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        
        // 2.设置尺寸
        sizeToFit()
    }
    
    convenience init(imageName:String, target:AnyObject, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(title:String, target:AnyObject, action:Selector) {
        self.init()
        setTitle(title, for: UIControlState.normal)
        sizeToFit()
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(imageName:String, title: String, target:AnyObject, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(UIImage(named: imageName), for: .normal)
//        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setTitle(title, for: UIControlState.normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }

}
