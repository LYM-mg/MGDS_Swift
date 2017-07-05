//
//  AnchorViewModel.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/2/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class AnchorViewModel: NSObject {
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    var liveID: Int = 0
    // MARK:- 懒加载属性
    lazy var cycleModels : [CycleModel] = [CycleModel]()
    lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    lazy var prettyGroup : AnchorGroup = AnchorGroup()
}

extension AnchorViewModel {
    func loadAnchorData(isGroupData : Bool, URLString : String, parameters : [String : Any]? = nil, finishedCallback : @escaping (_ err: Error?) -> ()) {
        NetWorkTools.requestData(type: .get, urlString: URLString, parameters: parameters, succeed: { (result, er) in
            // 1.对界面进行处理
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            
            // 2.判断是否分组数据
            if isGroupData {
                // 2.1.遍历数组中的字典
                for dict in dataArray {
                    self.anchorGroups.append(AnchorGroup(dict: dict))
                }
            } else  {
                // 2.1.创建组
                let group = AnchorGroup()
            
                // 2.2.遍历dataArray的所有的字典
                for dict in dataArray {
                    group.anchors.append(AnchorModel(dict: dict))
                }
            
                // 2.3.将group,添加到anchorGroups
                self.anchorGroups.append(group)
            }
            
            // 3.完成回调
            finishedCallback(nil)
        }) { (err) in
            finishedCallback(err)
        }
    }
}

// MARK:- 发送网络请求
extension AnchorViewModel {
    // 请求推荐数据
    func requestData(_ finishCallback : @escaping (_ err: Error?) -> ()) {
        // 1.定义参数
        let parameters = ["limit" : "4", "offset" : "0", "time" : Date.getCurrentTime()]
        
        // 2.创建Group
        let dGroup = DispatchGroup()
        
        // 3.请求第一部分推荐数据
        dGroup.enter()
        
        NetWorkTools.requestData(type: .get, urlString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", succeed: { (result, err) in
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data该key,获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历字典,并且转成模型对象
            // 3.1.设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            // 3.2.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            
            // 3.3.离开组
            dGroup.leave()
            // 3.完成回调

        }) { (err) in

        }

        
        // 4.请求第二部分颜值数据
        dGroup.enter()
        NetWorkTools.requestData(type: .get, urlString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", succeed: { (result, err) in
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data该key,获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历字典,并且转成模型对象
            // 3.1.设置组的属性
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            
            // 3.2.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.prettyGroup.anchors.append(anchor)
            }
            
            // 3.3.离开组
            dGroup.leave()
        }, failure: { (err) in
            finishCallback(err)
        })

        // 5.请求2-12部分游戏数据
        dGroup.enter()
        // http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1474252024
        loadAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { _ in
            dGroup.leave()
        }
        
        
        // 6.所有的数据都请求到,之后进行排序
        dGroup.notify(queue: DispatchQueue.main) {
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            finishCallback(nil)
        }
    }
    
    // 请求无线轮播的数据
    func requestCycleData(_ finishCallback : @escaping (_ err: Error?) -> ()) {
        NetWorkTools.requestData(type: .get, urlString: "http://www.douyutv.com/api/v1/slide/6",parameters: ["version" : "2.300"], succeed: { (result, err) in
            // 1.获取整体字典数据
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.字典转模型对象
            for dict in dataArray {
                self.cycleModels.append(CycleModel(dict: dict))
            }
            
            finishCallback(nil)
        }, failure: { (err) in
            finishCallback(err)
        })
    }
}
