//
//  MGVideoModel.swift
//  视频播放测试
//
//  Created by i-Techsys.com on 16/12/28.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

class MGVideoModel: NSObject {
    /** 标题 */
    var title: String?
    /** 描述 */
    var video_description: String?
    /** 视频地址 */
   var playUrl: String?
    /** 封面图 */
   var coverForFeed: String?
    /** 视频分辨率的数组 */
   var playInfo: [MGVideoResolution] = [MGVideoResolution]()
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    override func setValue(_ value: Any?, forKey key: String) {
        // 1.判断当前取出的key是否是用户
        if key == "playInfo" {
            var models = [MGVideoResolution]()
            for dict in value as! [[String: AnyObject]] {
                models.append(MGVideoResolution(dict: dict))
            }
            playInfo = models
            return
        }
        
        super.setValue(value, forKey: key)
    }
}
