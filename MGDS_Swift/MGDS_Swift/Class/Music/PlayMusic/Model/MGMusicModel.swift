//
//  MGMusicModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/4.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGMusicModel: NSObject {
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
