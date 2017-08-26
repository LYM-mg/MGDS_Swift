//
//  MGVideoResolution.swift
//  视频播放测试
//
//  Created by i-Techsys.com on 16/12/28.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

class MGVideoResolution: NSObject {
    var height: Int = 0
    var width: Int = 0
    var name: String = ""
    var type: String = ""
    var url: String = ""
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
