//
//  MGLrcModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class LrcModel: NSObject {
    /** 歌词开始时间 */
    var beginTime: Double = 0.0
    
    /** 歌词结束时间 */
    var endTime: Double = 0.0
    
    /** 歌词内容 */
    var lrcText: String = ""
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }

}
