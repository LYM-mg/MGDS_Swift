//
//  MoreModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MoreModel: BaseModel {
    var avatar: String!
    var charge: NSNumber!
    var gameIcon: String!
    var gameId: NSNumber!
    var gameName: String!
    var mic: NSNumber!
    var name: String!
    var pic51: String!
    var pic74: String!
    var roomid: String!
    var uid: String!
    var weeklyStar: NSNumber!
    var yearParty: NSNumber!
    var live: Int = 0 // 是否在直播
    var push: Int = 0 // 直播显示方式
    var focus: Int = 0 // 关注数
    
    var isEvenIndex : Bool = false
}
