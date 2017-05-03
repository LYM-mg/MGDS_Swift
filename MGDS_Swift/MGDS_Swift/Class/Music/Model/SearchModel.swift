//
//  SearchModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/4/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class SearchModel: NSObject {
    var album :[[String: Any]]! {
        didSet {
            for oneAlbum in album {
                albumArray.append(ArtList(dict: oneAlbum))
            }
        }
    }

    var artist : [[String: Any]]! {
        didSet {
            for one in artist {
                artistArray.append(ArtList(dict: one))
            }
        }
    }

    var errorCode : NSNumber!
    var order : String!
    var song: [[String: Any]]! {
        didSet {
            for oneSone in song {
                songArray.append(ArtList(dict: oneSone))
            }
        }
    }
    lazy var songArray = [ArtList]()
    lazy var albumArray = [ArtList]()
    lazy var artistArray = [ArtList]()
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
