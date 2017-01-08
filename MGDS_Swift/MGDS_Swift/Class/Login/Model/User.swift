//
//  User.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class User: NSObject{
    
    
    var id:Int = 0
    var nickName:String = ""
    var password:String = ""
    var headImage:String = ""
    var phone:String = ""
    var gender:Int = 0
    var platformId:String = ""
    var platformName:String = ""
    //    var isCollectStatus = 0
    
    
    init(id:Int,nickName:String,password:String,headImage:String,phone:String,gender:Int,platformId:String,platformName:String){
        
        self.id = id
        self.nickName = nickName
        
        self.password = password
        self.headImage = headImage
        self.phone = phone
        self.gender = gender
        self.platformId = platformId
        self.platformName = platformName
        
    }
    
    override init(){
        super.init()
        self.id = 0
        self.nickName = ""
        
        self.password = ""
        self.headImage = ""
        self.phone = ""
        self.gender = 0
        self.platformId = ""
        self.platformName = ""
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
