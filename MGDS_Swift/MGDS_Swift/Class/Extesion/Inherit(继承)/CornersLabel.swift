//
//  CornersLabel.swift
//  chart2
//
//  Created by i-Techsys.com on 16/11/25.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

class CornersLabel: UILabel {
//    override func draw(_ rect: CGRect) {
//        let pathRect = self.bounds.insetBy(dx: 1, dy: 1)
//        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 14)
//        path.lineWidth = 1
//        UIColor.white.setFill()
//        UIColor.blue.setStroke()
//        path.fill()
//        path.stroke()
//    }
}

extension CornersLabel {
    override open func draw(_ rect: CGRect) {
        let maskPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: 0, height: 8))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    
//    override func draw(_ rect: CGRect) {
//        
//        let width = self.bounds.size.width
//        let height = self.bounds.size.height
//        //创建上下文
//        let context = UIGraphicsGetCurrentContext()
//        //设置填充的颜色
//        context!.setFillColor(UIColor.red.cgColor)
//        //起始位置
//        context?.move(to: CGPoint.zero)
//        
//        //(0,0)到(width,0)
//        context?.addLine(to: CGPoint(x: width, y: 0))
//        
//        //圆角半径为10，设置右下角的圆角
//        context?.addArc(tangent1End: CGPoint(x: width, y: height), tangent2End: CGPoint(x: width-10, y: height-10), radius: 10)
//        
//        //设置左下角的圆角
//        context?.addArc(tangent1End: CGPoint(x: 0, y: height), tangent2End: CGPoint.zero, radius: 10)
//        
//        //闭合
//        context!.closePath()
//        //画出来
//        context!.drawPath(using: CGPathDrawingMode.fill);
//    }

}
