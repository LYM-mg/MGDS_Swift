//
//  User.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class User: NSObject,NSCoding{
    
    
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
    
    // MARK: -
    // MARK: - NSCoding
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
//        id = aDecoder.decodeObject(forKey: "ID") as! Int
        nickName = aDecoder.decodeObject(forKey: "NickName") as! String
        password = aDecoder.decodeObject(forKey: "Password") as! String
        headImage = aDecoder.decodeObject(forKey: "HeadImage") as! String
        phone = aDecoder.decodeObject(forKey: "Phone") as! String
//        gender = aDecoder.decodeObject(forKey: "Gender") as! Int
        platformId = aDecoder.decodeObject(forKey: "PlatformId") as! String
        platformName = aDecoder.decodeObject(forKey: "PlatformName") as! String

    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) {
//        aCoder.encode(id, forKey: "Id")
        aCoder.encode(nickName, forKey: "NickName")
        aCoder.encode(password, forKey: "Password")
        aCoder.encode(headImage, forKey: "HeadImage")
        aCoder.encode(phone, forKey: "Phone")
//        aCoder.encode(gender, forKey: "Gender")
        aCoder.encode(platformId, forKey: "PlatformId")
        aCoder.encode(platformName, forKey: "PlatformName")        
    }
}
