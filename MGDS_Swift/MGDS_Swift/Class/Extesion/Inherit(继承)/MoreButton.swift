//
//  MoreButton.swift
//  chart2
//
//  Created by i-Techsys.com on 16/12/9.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

class MoreButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置字体颜色
        self.setTitleColor(UIColor.colorWithCustom(r: 10, g: 10, b: 10), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        // 让文字居中显示
        self.titleLabel?.textAlignment = NSTextAlignment.center;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.mg_y = self.mg_height * 0.15;
        self.imageView?.mg_centerX = self.mg_width * 0.5;
        
        // 调整文字位置
        self.titleLabel?.mg_width = self.mg_width;
        self.titleLabel?.mg_height = self.mg_height - self.imageView!.mg_height;
        self.titleLabel?.mg_x = 0;
        self.titleLabel?.mg_y = self.imageView!.frame.maxY
    }
}
