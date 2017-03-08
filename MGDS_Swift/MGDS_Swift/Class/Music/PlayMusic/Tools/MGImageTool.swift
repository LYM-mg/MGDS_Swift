//
//  MGImageTool.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGImageTool: NSObject {

    static func creatImageWithText(text: String,InImage image: UIImage) -> UIImage? {
        // 开启位图上下文
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        // 将文字绘制到图片上面
        let rect = CGRect(origin: CGPoint(x: 0, y: image.size.height*0.4), size: image.size)
        
        // 设置文字样式
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let dict: [String: Any] =  [
                                    NSFontAttributeName:UIFont.systemFont(ofSize: 20),
                                    NSForegroundColorAttributeName: UIColor.green,
                                    NSParagraphStyleAttributeName : style
                                   ]
        (text as NSString).draw(in: rect, withAttributes: dict)
        
        // 获取最新的图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext();
        return resultImage
    }
}
