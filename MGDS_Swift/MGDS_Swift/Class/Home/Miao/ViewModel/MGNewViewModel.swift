//
//  MGNewViewModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGNewViewModel: NSObject {
    /** 当前页 */
    var currentPage: Int = 1
    /** 用户 */
    var anchors = [MGAnchor]()
}

extension MGNewViewModel {
    func getHotData(finishedCallBack: @escaping (_ err: Error?) -> ())  {
        NetWorkTools.requestData(type: .get, urlString: "http://live.9158.com/Room/GetNewRoomOnline?page=\(self.currentPage)", succeed: { [unowned self] (result, err) in
            guard let result = result as? [String: Any] else { return }
            guard let data = result["data"] as? [String: Any] else { return }
            guard let dictArr = data["list"] as? [[String: Any]] else { return }
            
            for anchorDict in dictArr {
                let anchor = MGAnchor(dict: anchorDict)
                self.anchors.append(anchor)
            }
            
            finishedCallBack(nil)
        }) { (err) in
            finishedCallBack(err)
        }
    }
}
