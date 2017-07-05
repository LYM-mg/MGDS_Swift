
//
//  FindViewModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class FindViewModel: NSObject {
    lazy var anchorModels = [MoreModel]()
}

extension FindViewModel {
    func loadContentData(_ complection:  @escaping (_ error: Error?) -> ()) {
        
        NetWorkTools.requestData(type: .get, urlString: "http://qf.56.com/home/v4/guess.ios", parameters: ["count" : 200], succeed: { (result, err) in
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
            
            // 4.转成模型对象
            for  dict in dataArray {
                self.anchorModels.append(MoreModel(dict: dict))
            }
            
            complection(nil)
        }) { (err) in
            complection(err)
        }
    }
    
    /// 返回cell的高度
//    func cellHeight(models :[MoreModel]) -> CGFloat {
//        return (120) * CGFloat((((models == nil) ? 1 : models.count) + 2) / 3) + 20
//    }
}



