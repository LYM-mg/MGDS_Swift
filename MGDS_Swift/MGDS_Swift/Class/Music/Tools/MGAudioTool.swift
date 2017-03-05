//
//  MGAudioTool.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGAudioTool: NSObject {
    /** 播放器对象 */
    fileprivate var player: AVAudioPlayer?
    weak var delegate: AVAudioPlayerDelegate? {
        didSet {
            self.player?.delegate = delegate
        }
    }
    
    /** 当前播放的路径 */
    var currentPlayURL: URL?
    
    
    func playAudioWith(urlStr: String) -> AVAudioPlayer?{
        if (urlStr == "") {
            return nil
        }
        
        
        if self.currentPlayURL?.absoluteString == urlStr {
            self.player?.play()
            return nil
        }
        
        // "/Users/ZBKF001/Library/Developer/CoreSimulator/Devices/A4E38A94-59E6-455E-A92C-8340FF650EA8/data/Containers/Data/Application/62473072-48F5-4F11-837E-5C558F68A4C5/Documents/刚好遇见你.mp3"
        // 根据资源路径, 创建播放器对象
        
        let url = URL(fileURLWithPath: urlStr)
        self.player = try! AVAudioPlayer(contentsOf: url)
        self.currentPlayURL = url
        
        // 开始播放
        self.player?.prepareToPlay()
        self.player?.play()

       
        return self.player
    }
    
    // 暂停播放
    func pauseAudio(){
        player?.pause()
    }
    
    // 停止播放
     func stopAudio() {
         player?.stop()
    }
    
    // 后台播放
     func backPlay() {
        let session = AVAudioSession.sharedInstance()
        /**
         *  AVAudioSessionCategoryAmbient;  播放当前的声音允许播放其他声音
         *  AVAudioSessionCategorySoloAmbien; 只播放当前的声音，其他声音停止
         *  AVAudioSessionCategoryPlayback; 跟着音乐的路径播放
         */
        try? session.setCategory(AVAudioSessionCategoryPlayback)
        try? session.setActive(true)
    }

    
    /**
     *  根据时间播放
     */
    func seekToTimeInterval(currentTime: TimeInterval){
        self.player?.currentTime = currentTime
    }

}


