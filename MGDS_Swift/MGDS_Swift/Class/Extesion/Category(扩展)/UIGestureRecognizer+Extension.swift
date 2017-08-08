//
//  UIGestureRecognizer+Extension.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/8/1.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//  封装的手势闭包回调

import UIKit

extension UIGestureRecognizer {
    typealias MGGestureBlock = ((Any)->())
    // MARK:- RuntimeKey   动态绑属性
    // 改进写法【推荐】
    fileprivate struct RuntimeKey {
        static let mg_GestureBlockKey = UnsafeRawPointer.init(bitPattern: "mg_GestureBlockKey".hashValue)
        /// ...其他Key声明
    }
    
    convenience init(actionBlock: @escaping MGGestureBlock) {
        self.init()
        addActionBlock(actionBlock)
        addTarget(self, action: #selector(invoke(_:)))
    }
    
    fileprivate func addActionBlock(_ block: MGGestureBlock?) {
        if (block != nil) {
            objc_setAssociatedObject(self, UIGestureRecognizer.RuntimeKey.mg_GestureBlockKey, block!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc fileprivate func invoke(_ sender: Any) {
        let block = objc_getAssociatedObject(self, UIGestureRecognizer.RuntimeKey.mg_GestureBlockKey) as? MGGestureBlock
        if (block != nil) {
            block!(sender);
        }
    }
}
