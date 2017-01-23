//
//  MGHotModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGHotModel: NSObject {
    // MARK: - 属性
    /** 直播图 */
    var bigpic: String!
    /** 主播头像 */
    var smallpic: String!
    /** 直播流地址 */
    var flv: String!
    /** 所在城市 */
    var gps: String!
    /** 主播名 */
    var myname: String!
    /** 个性签名 */
    var signatures: String!
    /** 用户ID */
    var userId: String!
    /** 民族 */
    var nation : String!
    /** 民族Flag */
    var nationFlag : String!
    
    /** 用户IDX */
    var useridx: NSNumber!
    /** 星级 */
    var starlevel: NSNumber! {
        didSet {
            if ((self.starlevel) != nil) {
                starImage = UIImage(named: "girl_star\(starlevel!)_40x19")
            }
        }
    }

    /** 朝阳群众数目 */
    var allnum: NSNumber!
    /** 这玩意未知 */
    var lrCurrent: NSNumber!
    /** 直播房间号码 */
    var roomid: NSNumber!
    /** 所处服务器 */
    var serverid: NSNumber!
    
    var isSign: NSNumber!
    var level: NSNumber!
    var grade: NSNumber!
    /** 排名 */
    var pos: NSNumber!
    /** starImage */
    var starImage: UIImage!
    
    // MARK: - 属性
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

//var allnum : Int!
//var curexp : Int!
//var distance : Int!
//var gender : Int!
//var grade : Int!
//var isSign : Int!
//var level : Int!
//var pos : Int!
//var roomid : Int!
//var serverid : Int!
//var starlevel : Int!
//var useridx : Int!
//
//var bigpic : String!
//var familyName : String!
//var flv : String!
//var gps : String!
//var myname : String!
//var nation : String!
//var nationFlag : String!
//var signatures : String!
//var smallpic : String!
//var userId : String!

