//
//  MGAVPlayerTool.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/3.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import AVKit

class MGAVPlayerTool: NSObject {
    fileprivate lazy var player: AVPlayer = AVPlayer()

    deinit {
        self.player.currentItem?.removeObserver(self, forKeyPath: "sattus")
    }

}

extension MGAVPlayerTool {
    func playMusicWith(urlStr: String) -> AVPlayer? {
        guard let url = URL(string: urlStr) else { return nil }
        //创建需要播放的AVPlayerItem
        let item = AVPlayerItem(url: url)
        //替换当前音乐资源
        self.player.replaceCurrentItem(with: item)
        
        /*
         typedef NS_ENUM(NSInteger, AVPlayerItemStatus) {
         AVPlayerItemStatusUnknown,//未知状态
         AVPlayerItemStatusReadyToPlay,//准备播放
         AVPlayerItemStatusFailed//加载失败
         };*/
        self.player.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        
        //KVO监听音乐缓冲状态
        self.player.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        return self.player
    }
    
    override func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
        //注意这里查看的是self.player.status属性
        if keyPath == "status" {
            switch (self.player.status) {
            case AVPlayerStatus.unknown:
                debugPrint("未知转态")
            case AVPlayerStatus.readyToPlay:
                debugPrint("准备播放")
            case AVPlayerStatus.failed:
                debugPrint("加载失")
            }
        }
        
        if keyPath == "loadedTimeRanges" {
//            self.loadTimeProgress.progress = scale
//            let timeRanges = (self.player.currentItem?.loadedTimeRanges)!
//            //本次缓冲的时间范围
//            let timeRange: CMTimeRange = timeRanges.first.cmTimeRange
//            //缓冲总长度
//            let totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
//            //音乐的总时间
//            let duration = CMTimeGetSeconds((self.player.currentItem?.duration)!);
//            //计算缓冲百分比例
//            let scale = totalLoadTime/duration;
//更新缓冲进度条
//            self.loadTimeProgress.progress = scale;
        }
    }
    
}
