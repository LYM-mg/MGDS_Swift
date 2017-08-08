//
//  UIBarButtonItem+Extension.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 2017/5/9.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    // UIBarButtonItem的封装
    convenience init(image: UIImage? = nil, highImage: UIImage? = nil, norColor: UIColor? = UIColor.white, selColor: UIColor? = UIColor.lightGray, title: String?, target: Any, action: Selector) {
        let backBtn = UIButton(type: .custom)
        /// 1.设置照片
        if image != nil {
            backBtn.setImage(image, for: .normal)
        }

        if highImage != nil {
            backBtn.setImage(highImage, for: .highlighted)
        }
        
        /// 2.设置文字以及颜色
        if title != nil {
             backBtn.setTitle(title, for: .normal)
        }
       
        backBtn.setTitleColor(norColor, for: .normal)
        backBtn.setTitleColor(selColor, for: .highlighted)
        backBtn.sizeToFit()
        backBtn.addTarget(target, action: action, for: .touchUpInside)
        backBtn.contentHorizontalAlignment = .left
        backBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        backBtn.titleEdgeInsets  = UIEdgeInsetsMake(0, -2, 0, 0)
        
        self.init(customView: backBtn)
    }
    
    // UIBarButtonItem的封装
    convenience init(image: UIImage, highImage: UIImage? = nil,title: String, target: Any, action: Selector) {
        self.init(image: image, highImage: highImage, norColor: UIColor.white, selColor: UIColor.lightGray, title: title, target: target, action: action)
    }
    
    convenience init(image: UIImage, highImage: UIImage? = nil, target: Any, action: Selector) {
        self.init(image: image, highImage: highImage, norColor: UIColor.white, selColor: UIColor.lightGray, title: nil, target: target, action: action)
    }
    
    convenience init(title: String, target: Any, action: Selector) {
        self.init(image: nil, highImage: nil, norColor: UIColor.white, selColor: UIColor.lightGray, title: title, target: target, action: action)
    }
}
