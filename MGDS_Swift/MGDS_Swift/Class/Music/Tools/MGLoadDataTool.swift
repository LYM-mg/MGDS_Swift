//
//  MGLoadDataTool.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGLoadDataTool: NSObject {
    static func loadMusicData(type: String,resultBlock: @escaping (_ musics: [SongDetail]?) -> ()) {
        var musicArr = [SongDetail]()
        let parameters: [String: Any] = ["method":"baidu.ting.billboard.billList","offset":"0","size":"100","type":type,"from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json"]
        NetWorkTools.requestData(type: .get, urlString: "http://tingapi.ting.baidu.com/v1/restserver/ting",parameters: parameters,succeed: {(result, err) in
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : Any] else { return }
            
            // 2.根据data该key,获取数组
            guard let dataArray = resultDict["song_list"] as? [[String : Any]] else { return }
            
            for mdict in dataArray {
                musicArr.append(SongDetail(dict: mdict))
            }
            resultBlock(musicArr)
        }) { (err) in
           resultBlock(nil)
        }

    }
}
