//
//  MGLrcLoadTool.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGLrcLoadTool: NSObject {
//    static let share = MGLrcLoadTool()
    class func getNetLrcModelsWithUrl(urlStr: String, finished:@escaping ((_ lrcMs: [MGLrcModel] )->())) {
        NetWorkTools.share.downloadData(type: .get, urlString: urlStr) { (path) in
            let lrc = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            
            guard let lrcStrs = lrc?.components(separatedBy: "\n") else { return }
            var lrcMs: [MGLrcModel] = [MGLrcModel]()
            for lrc in lrcStrs {
                if lrc.hasPrefix("[ti:") || lrc.hasPrefix("[ar:") || lrc.hasPrefix("[al:") || lrc.hasPrefix("[by") || lrc.hasPrefix("[offset") ||  lrc.hasPrefix("[ml") {
                    continue
                }
                
                if lrc.contains("[") || lrc.contains("]") {
                    /// 正常解析歌词
                    // 1.去掉@“[”
                    let timeAndText = lrc.replacingOccurrences(of: "[", with: "")
                    // 2.将时间和歌词分开
                    let lrcStrArray = timeAndText.components(separatedBy: "]")
                    let time = lrcStrArray.first
                    let lrcText = lrcStrArray.last
                    
                    // 3.创建一个模型 (开始时间  和  歌词)
                    let lrcModel = MGLrcModel()
                    if time != "" {
                        lrcModel.beginTime = MGTimeTool.getTimeIntervalWithFormatTime(format: time!)
                    }
                    lrcModel.lrcText = lrcText!
                    lrcMs.append(lrcModel)
                } else {
                    // 3.创建一个模型 (开始时间  和  歌词)
                    let lrcModel = MGLrcModel()
                    lrcModel.lrcText = lrc
                    lrcMs.append(lrcModel)
                }
            }
            
            // 给数据模型的结束时间赋值
            for i in 0..<lrcMs.count {
                if (i == lrcMs.count - 1) {
                    break;
                }
                let lrcM = lrcMs[i];
                let nextlrcM = lrcMs[i + 1]
                lrcM.endTime = nextlrcM.beginTime
            }
            
            finished(lrcMs)
        }
    }
    
    class func getRowWithCurrentTime(currentTime: TimeInterval,lrcMs: [MGLrcModel]) -> Int {
        for i in 0..<lrcMs.count {
            let lrcM = lrcMs[i]
            if (currentTime >= lrcM.beginTime && currentTime < lrcM.endTime) {
                return i
            }
        }
        return 0
    }
}

//[ti:0]
//[ar:0]
//[al:0]
//[by:0]
//[offset:0]
//[00:00.74]刚好遇见你
//[00:03.04]
//[00:04.63]作词：高进
//[00:06.17]作曲：高进
//[00:07.71]编曲：关天天
//[00:09.25]演唱：李玉刚
//[00:11.15]
//[00:14.00]我们哭了
//[00:16.88]我们笑着
//[00:20.03]我们抬头望天空
//[00:22.86]星星还亮着几颗
//[00:26.04]我们唱着
//[00:29.14]时间的歌
//[00:32.20]才懂得相互拥抱
//[00:35.21]到底是为了什么
//[00:37.85]
//[00:38.27]因为我刚好遇见你
//[00:41.72]留下足迹才美丽
//[00:44.81]风吹花落泪如雨
//[00:47.84]因为不想分离
//[00:50.95]
//[00:51.19]因为刚好遇见你
//[00:54.10]留下十年的期许
//[00:57.08]如果再相遇
//[01:00.39]我想我会记得你
//[01:03.54]
//[01:15.50]我们哭了
//[01:18.41]我们笑着
//[01:21.46]我们抬头望天空
//[01:24.36]星星还亮着几颗
//[01:27.70]我们唱着
//[01:30.64]时间的歌
//[01:33.78]才懂得相互拥抱
//[01:36.72]到底是为了什么
//[01:39.44]
//[01:39.83]因为我刚好遇见你
//[01:43.25]留下足迹才美丽
//[01:46.31]风吹花落泪如雨
//[01:49.32]因为不想分离
//[01:52.23]
//[01:52.57]因为刚好遇见你
//[01:55.57]留下十年的期许
//[01:58.57]如果再相遇
//[02:01.94]我想我会记得你
//[02:05.07]因为我刚好遇见你
//[02:06.82]留下足迹才美丽
//[02:09.78]风吹花落泪如雨
//[02:12.81]因为不想分离
//[02:15.70]
//[02:16.03]因为刚好遇见你
//[02:19.08]留下十年的期许
//[02:22.02]如果再相遇
//[02:25.43]我想我会记得你
//[02:29.01]
//[02:31.18]因为我刚好遇见你
//[02:34.44]留下足迹才美丽
//[02:37.47]风吹花落泪如雨
//[02:40.54]因为不想分离
//[02:43.35]
//[02:43.81]因为刚好遇见你
//[02:46.78]留下十年的期许
//[02:49.87]如果再相遇
//[02:52.97]我想我会记得你
//[02:56.83]
