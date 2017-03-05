//
//  Song.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/1.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class Song: NSObject {
    var title: String!
    var author: String!
    var song_id: String!
    var album_id: String!
    var album_title: String!
    var rank_change: String!
    var all_rate: String!
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
//    "title":"夏夜星空海",
//    "author":"张信哲",
//    "song_id":"533357685",
//    "album_id":"533357576",
//    "album_title":"夏夜星空海",
//    "rank_change":"0",
//    "all_rate":"64,128,256,320,flac"
