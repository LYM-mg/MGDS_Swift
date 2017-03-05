//
//  CALayer+Extension.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

extension CALayer {
    // 动画的暂停
    func pauseAnimate() {
        let pausedTime = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0;
        self.timeOffset = pausedTime
    }
    
    // 动画的恢复
    func resumeAnimate() {
        let pausedTime = self.timeOffset
        self.speed = 1.0;
        self.timeOffset = 0.0;
        self.beginTime = 0.0;
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause;
    }
}
