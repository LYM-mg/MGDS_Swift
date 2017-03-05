//
//  OneSong.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class OneSong: NSObject {
    var queryId: String!
    var songName: String!   // 歌名
    var artistId: NSNumber!
    var artistName: String!  // 歌手
    var albumId: NSNumber!
    var albumName: String!
    
    var songPicSmall: String!  // 图片
    var songPicBig: String!
    var songPicRadio: String!
    
    var lrcLink: String! // 歌词
    var time: NSNumber!
    var linkCode: NSNumber!
    var songLink: String! // 歌曲链接
    
    // 更高品质
    var showLink: String!
    var songId: NSNumber!

    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
//    "queryId":"276867440",
//    "songId":276867440,
//    "songName":"刚好遇见你",
//    "artistId":"1078",
//    "artistName":"李玉刚",
//    "albumId":276867491,
//    "albumName":"刚好遇见你",
//    "songPicSmall":"http://musicdata.baidu.com/data2/pic/46e568a3a6e226b660530c00a7c1e9ae/276867494/276867494.jpg@s_0,w_90",
//    "songPicBig":"http://musicdata.baidu.com/data2/pic/46e568a3a6e226b660530c00a7c1e9ae/276867494/276867494.jpg@s_0,w_150",
//    "songPicRadio":"http://musicdata.baidu.com/data2/pic/46e568a3a6e226b660530c00a7c1e9ae/276867494/276867494.jpg@s_0,w_300",
//    "lrcLink":"http://musicdata.baidu.com/data2/lrc/124788a17930411d87ece9f05e437b8d/533392121/533392121.lrc",
//    "version":"",
//    "copyType":0,
//    "time":200,
//    "linkCode":22000,
//    "songLink":"http://yinyueshiting.baidu.com/data2/music/5ad0b24804bb3324e55b4eb1510a1575/276868773/27686744028800128.mp3?xcode=b984bf5c32d031658c3c42cb27c397d9",
//    "showLink":"http://yinyueshiting.baidu.com/data2/music/5ad0b24804bb3324e55b4eb1510a1575/276868773/27686744028800128.mp3?xcode=b984bf5c32d031658c3c42cb27c397d9",
//    "format":"mp3",
//    "rate":128,
//    "size":3202047,
//    "relateStatus":"0",
//    "resourceType":"0",
//    "source":"web"
