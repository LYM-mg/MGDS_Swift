//
//  MoreViewModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MoreViewModel {
    lazy var anchorModels = [MoreModel]()
}

extension MoreViewModel {
    func loadMoreData(type : MoreType, index : Int,  finishedCallback: @escaping (_ error: Error?) -> ()) {
        NetWorkTools.requestData(type: .get, urlString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type" : type.type, "index" : index, "size" : 48], succeed: { (result, err) in
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
            
            for (index, dict) in dataArray.enumerated() {
                let anchor = MoreModel(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchor)
            }
            
            finishedCallback(nil)
        }) { (err) in
             finishedCallback(err)
        }
    }
}
