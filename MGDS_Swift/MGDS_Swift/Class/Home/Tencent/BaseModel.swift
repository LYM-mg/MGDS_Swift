//
//  BaseModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/18.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class BaseModel: NSObject {

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
