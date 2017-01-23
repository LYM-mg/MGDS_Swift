//
//  MGHotAD.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGHotAD: NSObject {
    /** 新增时间 */
    var addTime : String!
    /** 大图 */
    var bigpic : String!
    /** 直播流 */
    var flv : NSString!
    /** 所在城市 */
    var gps : NSString!
    /** AD图片 */
    var imageUrl : String!
    /** 链接 */
    var link : String!
    /** 主播名 */
    var myname : String!
    /** 个性签名 */
    var signatures : NSString!
    /** 主播头像 */
    var smallpic : NSString!
    var adsmallpic : String!
    var contents : String!
    /** AD名 */
    var title : String!
    var hiddenVer : Int!
    var lrCurrent : Int!
    var orderid : NSNumber!
    /** 房间号 */
    var roomid : NSNumber!
    /** 所在服务器号 */
    var serverid : NSNumber!
    /** 当前状态 */
    var state : NSNumber!
    /** 倒计时 */
    var cutTime : NSNumber!
    /** 主播ID */
    var useridx : NSNumber!
    
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
