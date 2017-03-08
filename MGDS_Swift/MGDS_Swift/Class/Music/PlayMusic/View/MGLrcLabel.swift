//
//  MGLrcLabel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGLrcLabel: UILabel {
    var progress: Double = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    fileprivate var lrcProgress: Double = 0.0
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 设置颜色
        UIColor.green.set()
        let fillRect = CGRect(origin: .zero, size: CGSize(width: rect.size.width*CGFloat(self.progress), height: rect.size.height))
        UIRectFillUsingBlendMode(fillRect, CGBlendMode.sourceIn)
//        UIRectFill(fillRect);
    }
}
