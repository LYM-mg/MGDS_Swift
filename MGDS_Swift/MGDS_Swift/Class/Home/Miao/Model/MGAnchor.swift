//
//  MGUser.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGAnchor: MGHotModel {
    // MARK: - 属性
    // MARK: String
    /** 直播地址 */
//    var flv: String?
    /** 昵称 */
    var nickname: String?
    /** 照片地址 */
    var photo: String?
    /** 所在地区 */
    var position: String?
    
    
    // MARK: NSNumber
    var newField: NSNumber!
    /** 性别 */
    var sex: NSNumber!
    /** 是否是新人 */
    var newStar: NSNumber!
//    var allnum : NSNumber!
    /** 房间号 */
//    var roomid: NSNumber?
    /** 服务器号 */
//    var serverid: NSNumber!
    /** 等级 */
//    var starlevel: NSNumber!
    
    /** 用户idX */
//    var useridx: NSNumber?
    
    // MARK: - 方法
    override init() {
        super.init()
    }
    
    override init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}

//var allnum : Int!
//var flv : String!
//var newField : Int!
//var nickname : String!
//var photo : String!
//var position : String!
//var roomid : Int!
//var serverid : Int!
//var sex : Int!
//var starlevel : Int!
//var useridx : Int!
