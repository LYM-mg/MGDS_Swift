//
//  MGMusicOperationTool.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// http://music.baidu.com/data/music/links?songIds=276867440

import UIKit

class MGMusicOperationTool: NSObject {
    static let share = MGMusicOperationTool()
    
    /** 存放的播放列表 */
    lazy var musicMs = [SongDetail]()
    /** 播放音乐的工具 */
    fileprivate var audioTool = MGAudioTool()
    /** 单个播放器的player */
    var currentPlayer: AVAudioPlayer?
    fileprivate var message : MGMessageModel = MGMessageModel()
    var currentMusic: OneSong?
    /** 记录当前音乐播放的下标 */
    var currentIndex: Int = 0 {
        didSet {
            let count = self.musicMs.count
            if (currentIndex < 0) {
                currentIndex = count - 1;
            }else if (currentIndex > count - 1){
                currentIndex = 0;
            }
        }
    }
    /** 代理 */
    weak var delegate: AVAudioPlayerDelegate? {
        didSet {
            self.audioTool.delegate = delegate
        }
    }
    
    override init() {
        super.init()
    }
    
    func getMusicMessageM() -> MGMessageModel{
        if musicMs.count == 0  { // || currentMusic == nil
           return message
        }
        // 获取当前歌曲播放时间和总时长
        message.costTime = self.currentPlayer!.currentTime
        message.totalTime = self.currentPlayer!.duration
        message.isPlaying = self.currentPlayer!.isPlaying

//        message.musicM = musicMs[currentIndex]
        message.musicM = self.currentMusic
        return message
    }
    
    // 根据模型播放音乐
    func playWithMusicName(musicM: SongDetail,index: Int){
        let parameters: [String: Any] = ["songIds": self.musicMs[index].song_id]
        NetWorkTools.requestData(type: .get, urlString: "http://ting.baidu.com/data/music/links", parameters: parameters, succeed: { (result, err) in
            guard let resultDict = result as? [String : Any] else { return }
            
            // 2.根据data该key,获取数组
            guard let resultDictArray = resultDict["data"] as? [String : Any] else { return }
            guard let dataArray = resultDictArray["songList"] as? [[String : Any]] else { return }
            self.currentMusic = OneSong(dict: dataArray.first!)
            
            self.currentIndex = self.musicMs.index(of: musicM)!
            self.getOneMusic(urlStr: self.currentMusic!.songLink)

            self.getMusicMessageM().musicM = self.currentMusic
        }) { (err) in
            
        }
    }
    
    func getOneMusic(urlStr: String) {
        NetWorkTools.share.downloadMusicData(type: .get, urlString: urlStr) { (filePath) in
            // "/Users/ZBKF001/Library/Developer/CoreSimulator/Devices/A4E38A94-59E6-455E-A92C-8340FF650EA8/data/Containers/Data/Application/62473072-48F5-4F11-837E-5C558F68A4C5/Documents/刚好遇见你.mp3"
            // 根据资源路径, 创建播放器对象
            self.currentPlayer = self.audioTool.playAudioWith(urlStr: filePath)
        }
    }

    /**
     *  暂停当前正在播放的音乐
     */
    func pauseCurrentMusic(){
        self.audioTool.pauseAudio()
    }
    
    /**
     *  继续播放当前的音乐
     */
    func playCurrentMusic() {
        let model = self.musicMs[self.currentIndex];
        self.playWithMusicName(musicM: model,index: currentIndex)
    }
    
    /**
     *  播放下一首音乐
     */
    func playNexttMusic() {
        self.currentIndex += 1
        let model = self.musicMs[self.currentIndex];
        self.playWithMusicName(musicM: model,index: currentIndex)
    }
    
    /**
     *  播放上一首音乐
     */
    func playPreMusic() {
        self.currentIndex -= 1
        let model = self.musicMs[self.currentIndex];
        self.playWithMusicName(musicM: model,index: currentIndex)
    }
    
    /**
     *  根据时间播放
     */
    func seekToTimeInterval(currentTime: TimeInterval){
        self.audioTool.seekToTimeInterval(currentTime: currentTime)
    }
    
}

class MGMessageModel: NSObject {
    /** 当前正在播放的音乐数据模型 */
    var  musicM: OneSong!

    /** 当前播放的时长 */
    var  costTime: Double = 0.0

    /** 当前播放总时长 */
    var  totalTime: Double = 0.0

    /** 当前的播放状态 */
    var isPlaying: Bool = false

}

