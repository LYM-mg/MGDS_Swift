//
//  CycleHeaderModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/23.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class CycleHeaderModel: NSObject {
    var bigimg : String!
    var brief : String!
    var channel : String!
    var classification : String!
    var details : String!
    var displayType : String!
    var endTime : String!
    var name : String!
    var newimg : String!
    var nickname : String!
    var notice : String!
    var order : String!
    var personNum : String!
    var picture : String! = ""
    var qcmsint1 : String!
    var qcmsint3 : String!
    var qcmsint4 : String!
    var qcmsint5 : String!
    var qcmsstr3 : String!
    var qcmsstr4 : String!
    var qcmsstr5 : String!
    var roomKey : String!
    var roomid : String!
    var roomurl : String!
    var schedule : String!
    var smallimg : String!
    var startTime : String!
    var status : String!
    var streamStatus : String!
    var styleType : String!
    var title : String!
    var url : String!
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
