//
//  SongGroup.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/1.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class SongGroup: NSObject {
    var name: String!
    var type: NSNumber!
    var count: NSNumber!
    
    var comment: String!
    var web_url: String!
    var song_id: String!
    var pic_s192: String!
    var pic_s444: String!
    
    var pic_s260: String!
    var pic_s210: String!
    
    var content: [[String : NSObject]]? {
        didSet {
            guard let content_list = content else { return }
            for dict in content_list {
                song_list.append(Song(dict: dict))
            }
        }
    }
    lazy var song_list : [Song] = [Song]()
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}

//    "name":"新歌榜",
//    "type":1,
//    "count":4,
//    "comment":"该榜单是根据百度音乐平台歌曲每日播放量自动生成的数据榜单，统计范围为近期发行的歌曲，每日更新一次",
//    "web_url":"",
//    "pic_s192":"http://b.hiphotos.baidu.com/ting/pic/item/9922720e0cf3d7caf39ebc10f11fbe096b63a968.jpg",
//    "pic_s444":"http://d.hiphotos.baidu.com/ting/pic/item/78310a55b319ebc4845c84eb8026cffc1e17169f.jpg",
//    "pic_s260":"http://b.hiphotos.baidu.com/ting/pic/item/e850352ac65c1038cb0f3cb0b0119313b07e894b.jpg",
//    "pic_s210":"http://business.cdn.qianqian.com/qianqian/pic/bos_client_c49310115801d43d42a98fdc357f6057.jpg",
//    "content"
