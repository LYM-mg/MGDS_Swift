//
//  DetailGameViewModel.swift
//  MGDYZB
//
//  Created by i-Techsys.com on 17/4/8.
//  Copyright © 2017年 ming. All rights reserved.
//

import UIKit

class DetailGameViewModel: NSObject {
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    var tag_id: String = "1"
    lazy var offset: NSInteger = 0
//    http://capi.douyucdn.cn/api/v1/live/1?limit=20&client_sys=ios&offset=0
//    http://capi.douyucdn.cn/api/v1/live/2?limit=20&client_sys=ios&offset=0
    
    func loadDetailGameData(_ finishedCallback: @escaping (_ err: Error?) -> ()) {
        let urlStr = "http://capi.douyucdn.cn/api/v1/live/\(tag_id)"
        let parameters: [String: Any] = ["limit": 20,"client_sys": "ios","offset": offset]
        
        NetWorkTools.requestData(type: .get, urlString: urlStr, parameters: parameters, succeed: { (result, er) in
            // 1.对界面进行处理
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            
            // 2.判断是否分组数据
//            if isGroupData {
//                // 2.1.遍历数组中的字典
//                for dict in dataArray {
//                    self.anchorGroups.append(AnchorGroup(dict: dict))
//                }
//            } else  {
                // 2.1.创建组
                let group = AnchorGroup()
                
                // 2.2.遍历dataArray的所有的字典
                for dict in dataArray {
                    group.anchors.append(AnchorModel(dict: dict))
                }
                
                // 2.3.将group,添加到anchorGroups
                self.anchorGroups.append(group)
//            }
            
            // 3.完成回调
            finishedCallback(nil)
        }) { (err) in
            finishedCallback(err)
        }

    }
}
