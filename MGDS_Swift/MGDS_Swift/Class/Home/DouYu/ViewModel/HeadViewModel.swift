//
//  HeadViewModel.swift
//  MGDYZB
//
//  Created by i-Techsys.com on 17/4/10.
//  Copyright © 2017年 ming. All rights reserved.
//

import UIKit

class HeadViewModel: AnchorViewModel {
    lazy var tag_id: Int = 0
    lazy var offset: Int = 0
        
/*
    http://capi.douyucdn.cn/api/v1/getVerticalRoom?limit=20&client_sys=ios&offset=0 // 颜值
    http://capi.douyucdn.cn/api/v1/live/1?limit=20&client_sys=ios&offset=0  // 英雄联盟
    http://capi.douyucdn.cn/api/v1/live/124?limit=20&client_sys=ios&offset=0  // 户外
    http://capi.douyucdn.cn/api/v1/live/148?limit=20&client_sys=ios&offset=0 // 守望先锋
 */
    func loadHearderData(_ finishCallback:  @escaping (_ err: Error?) -> ()) {
        let urlStr = "http://capi.douyucdn.cn/api/v1/live/\(tag_id)"
        let parameters: [String: Any] = ["limit": 20,"client_sys": "ios","offset": offset]
        loadAnchorData(isGroupData: false, URLString: urlStr, parameters: parameters, finishedCallback: finishCallback)
    }
}
