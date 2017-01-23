//
//  MGHotViewModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGHotViewModel: NSObject {
    /** 当前页 */
    var currentPage: Int = 1
    /** 直播 */
    var lives = [MGHotModel]()
    /** 头部数据广告 */
    var hotADS = [MGHotAD]()
}

extension MGHotViewModel {
    func getHotData(finishedCallBack: @escaping (_ err: Error?) -> ())  {
        NetWorkTools.requestData(type: .get, urlString: "http://live.9158.com/Fans/GetHotLive?page=\(self.currentPage)", succeed: { [unowned self] (result, err) in
            guard let result = result as? [String: Any] else { return }
            guard let data = result["data"] as? [String: Any] else { return }
            guard let dictArr = data["list"] as? [[String: Any]] else { return }
            
            for liveDict in dictArr {
                let live = MGHotModel(dict: liveDict)
                self.lives.append(live)
            }
 
           finishedCallBack(nil)
        }) { (err) in
           finishedCallBack(err)
        }
    }
    
    // 请求无线轮播的数据
    func getCycleData(finishedCallBack: @escaping (_ err: Error?) -> ())  {
        NetWorkTools.requestData(type: .get, urlString: "http://live.9158.com/Living/GetAD", succeed: { [unowned self] (result, err) in
            guard let result = result as? [String: Any] else { return }
            guard  let dictArr = result["data"] as? [[String: Any]]  else { return }
            
            self.hotADS.removeAll()
            for hotADDict in dictArr {
                let hotAD = MGHotAD(dict: hotADDict)
                self.hotADS.append(hotAD)
            }
            
            finishedCallBack(nil)
        }) { (err) in
            finishedCallBack(err)
        }
    }
}
