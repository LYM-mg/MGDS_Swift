//
//  MGOrderButton.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGOrderButton: UIButton {
    // MARK:- 属性
    var orderIndex: UInt = 1
    
    /** lazy */
    fileprivate lazy var tipLabel: UILabel = {
        let lb = UILabel(frame: CGRect(x: 0, y: -40, width: 80, height: 30))
        lb.backgroundColor = UIColor.black
        lb.textAlignment = NSTextAlignment.center
        lb.textColor = UIColor.white
        return lb
    }()

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(MGOrderButton.onClick), for: .touchUpInside)
    }
    
    @objc func onClick() {
        self.isEnabled = false
        self.addSubview(tipLabel)
        tipLabel.alpha = 0.0
        let scale = CGAffineTransform(scaleX: 0, y: 0)
        let translation  = CGAffineTransform(translationX: 0, y: -80)
        tipLabel.transform = scale.concatenating(translation)
        
        orderIndex += 1
        if orderIndex > 3 {
            orderIndex = 1
        }
        switch(orderIndex) {
            case 1:
                setImage(UIImage(named: "icon_ios_replay"), for: .normal)
                tipLabel.text = "顺序播放"
            case 2:
                setImage(UIImage(named: "icon_ios_shuffle"), for: .normal)
                tipLabel.text = "随机播放"
            case 3:
                setImage(UIImage(named: "loop_single_icon"), for: .normal)
                tipLabel.text = "单曲播放"
            default:
                break
        }
        
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 8, options: UIViewAnimationOptions.transitionFlipFromTop, animations: { () -> Void in
            self.tipLabel.alpha = 1.0
            self.tipLabel.transform = CGAffineTransform.identity
        }) { (_) -> Void in
            self.isEnabled = true
            self.tipLabel.removeFromSuperview()
        }
    }
}
