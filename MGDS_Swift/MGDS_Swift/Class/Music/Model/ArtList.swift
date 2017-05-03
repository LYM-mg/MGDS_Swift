//
//  ArtList.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/4/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class ArtList: NSObject {
    // MARK: - song
    var artistname : String!
    var bitrateFee : String!
    var control : String!
    var encryptedSongid : String!
    var hasMv : String!
    var info : String!
    var resourceProvider : String!
    var resourceTypeExt : String!
    var songid : String!
    var songname : String!
    var weight : String!
    var yyrArtist : String!
    
    // MARK: - album
    var albumid : String!
    var albumname : String!
    var artistpic : String!
//    var artistname : String!
//    var resourceTypeExt : String!
//    var weight : String!
    
    // MARK: - artist
    var artistid : String!
//    var artistname : String!
//    var artistpic : String!
//    var weight : String!
//    var yyrArtist : String!
    
    
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
