//
//  MGPlayMusicTool.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/4.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MGPlayMusicTool: NSObject {
    static let _playingMusic = NSMutableDictionary()  // 利用字典 URL作为唯一key播放
    static let _indicator = MGMusicIndicator.share
    
    override class func initialize() {
        super.initialize()
//        _playingMusic =
    }
}

// MARK: - 播放相关
extension MGPlayMusicTool {
    class func setUpCurrentPlayingTime(time: CMTime,link: String) {
        let playerItem: AVPlayerItem = MGPlayMusicTool._playingMusic[link] as! AVPlayerItem
        let queue = MGPlayerQueue.share
        playerItem.seek(to: time) { (_) in
            MGPlayMusicTool._playingMusic.setValue(playerItem, forKey: link)
            queue.play()
            _indicator.state = .playing
        }
    }
    
    // 播放▶️音乐🎵
    class func playMusicWithLink(link: String) -> AVPlayerItem{
        let queue = MGPlayerQueue.share
        var playerItem: AVPlayerItem? = MGPlayMusicTool._playingMusic[link] as? AVPlayerItem
        if playerItem == nil {
            playerItem = AVPlayerItem(url: URL(string: link)!)
            MGPlayMusicTool._playingMusic.setValue(playerItem, forKey: link)
            queue.replaceCurrentItem(with: playerItem)
        }
        queue.play()
        _indicator.state = .playing
        return playerItem!
    }
    
    // 暂停⏸音乐🎵
    static func pauseMusicWithLink(link: String) {
        let playerItem: AVPlayerItem? = MGPlayMusicTool._playingMusic[link] as? AVPlayerItem
        if playerItem != nil {
            let queue = MGPlayerQueue.share
            queue.pause()
            _indicator.state = .paused
        }
    }
    
    // 停止⏹音乐🎵
    static func stopMusicWithLink(link: String) {
        let playerItem: AVPlayerItem? = MGPlayMusicTool._playingMusic[link] as? AVPlayerItem
        if playerItem != nil {
            let queue = MGPlayerQueue.share
            queue.remove(playerItem!)
            queue.removeAllItems()
            _playingMusic.removeAllObjects()
        }
    }
}
