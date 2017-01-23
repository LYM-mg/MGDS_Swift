//
//  VideoList.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/18.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class VideoList: BaseModel {
    var cover : String!
    var descriptionField : String!
    var length : NSNumber!
    var m3u8Hd_url : String!
    var m3u8_url : String!
    var mp4Hd_url : String!
    var mp4_url : String!
    var playCount : NSNumber! 
//    var palyCountStr: String!
    var playersize : NSNumber!
    var ptime : String!
    var replyBoard : String!
    var replyid : String!
    var sectiontitle : String!
    var title : String!
    var topicDesc : String!
    var topicImg : String!
    var topicName : String!
    var topicSid : String!
    var vid : String!
    var videoTopic : VideoTopic!
    var videosource : String!
    
    override init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
}
