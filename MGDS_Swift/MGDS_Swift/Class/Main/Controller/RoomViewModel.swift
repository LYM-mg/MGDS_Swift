//
//  RoomViewModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class RoomViewModel: NSObject {
    lazy var liveURL : String = ""
}

extension RoomViewModel {
    func loadLiveURL(_ roomid : String, _ userId : String, _ completion : @escaping (_ error: Error?) -> ()) {
        let URLString = "http://qf.56.com/play/v2/preLoading.ios"
        let parameters : [String : Any] = ["imei" : "36301BB0-8BBA-48B0-91F5-33F1517FA056",
                                           "roomId" : roomid,
                                           "signature" : "f69f4d7d2feb3840f9294179cbcb913f",
                                           "userId" : userId]
        NetWorkTools.requestData(type: .get, urlString: URLString, parameters: parameters, succeed: { (result, err) in
            // 1.获取结果字典
            guard let resultDict = result as? [String : Any] else { return }
            
            // 2.获取信息
            guard let msgDict = resultDict["message"] as? [String : Any] else { return }
            
            // 3.获取直播的请求地址
            guard let requestURL = msgDict["rUrl"] as? String else { return }
            
            // 4.请求直播地址
            self.loadOnliveURL(requestURL, completion)
        }) { (err) in
            self.loadOnliveURL("", completion)
        }
    }
    
    fileprivate func loadOnliveURL(_ URLString : String, _ complection : @escaping (_ error: Error?) -> ()) {
        NetWorkTools.requestData(type: .get, urlString: URLString, succeed: { (result, err) in
            // 1.获取结果字典
            guard let resultDict = result as? [String : Any] else { return }
            
            // 2.获取地址
            guard let liveURL = resultDict["url"] as? String else { return }
            
            // 3.保存地址
            self.liveURL = liveURL
            
            // 4.回调出去
            complection(nil)
        }) { (err) in
             complection(err)
        }
    }
}
