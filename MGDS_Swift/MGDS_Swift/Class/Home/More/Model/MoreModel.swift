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
    var charge: Int!
    var gameIcon: String!
    var gameId: Int!
    var gameName: String!
    var mic: Int!
    var name: String!
    var pic51: String!
    var pic74: String!
    var roomid: String!
    var uid: String!
    var weeklyStar: Int!
    var yearParty: Int!
    var live: Int = 0 // 是否在直播
    var push: Int = 0 // 直播显示方式
    var focus: Int = 0 // 关注数
    
    var isEvenIndex : Bool = false
}
