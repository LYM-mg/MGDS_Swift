//
//  MGWelcomeAVPlayerViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/5/3.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import AVKit

class MGWelcomeAVPlayerViewController: UIViewController {

    // MARK: - 属性
    fileprivate lazy var playerVc = AVPlayerViewController()
    var urlStr: String? = ""
    
    convenience init(urlStr: String) {
        self.init(nibName: nil, bundle: nil)
        self.urlStr = urlStr
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setUpUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        debugPrint("MGWelcomeAVPlayerViewController--deinit")
    }
}

// MARK: - setUpUI
extension MGWelcomeAVPlayerViewController {
    fileprivate func setUpUI() {
        setUpWelcomeAVPlayerView()
        setUpWelcomeBtn()
        // 播放结束通知
        MGNotificationCenter.addObserver(self, selector: #selector(self.enterMainAction(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    fileprivate func setUpWelcomeAVPlayerView() {
        let url = URL(fileURLWithPath: self.urlStr!)
        let player = AVPlayer(url: url)
        playerVc.player = player
        playerVc.showsPlaybackControls = false
        // 设置播放视图的frame
        self.playerVc.view.frame = self.view.frame;
        // 添加播放视图到要显示的视图
        self.view.addSubview(self.playerVc.view)
        
        //设置视频播放界面的尺寸缩放选项
        /*
             可以设置的值及意义如下：
             AVLayerVideoGravityResizeAspect   不进行比例缩放 以宽高中长的一边充满为基准
             AVLayerVideoGravityResizeAspectFill 不进行比例缩放 以宽高中短的一边充满为基准
             AVLayerVideoGravityResize     进行缩放充满屏幕
         */
        playerVc.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //播放视频
        if #available(iOS 10.0, *) {
            playerVc.player?.automaticallyWaitsToMinimizeStalling  = false
        }
        
        playerVc.player?.play()
    }
    
    fileprivate func setUpWelcomeBtn() {
        // 进入按钮
        let enterMainButton = UIButton()
        enterMainButton.frame = CGRect(x: 24, y: playerVc.view.bounds.size.height - 32 - 48, width: UIScreen.main.bounds.size.width - 48, height: 48)
        enterMainButton.layer.borderWidth = 1
        enterMainButton.layer.cornerRadius = 24
        enterMainButton.layer.borderColor = UIColor.white.cgColor
        enterMainButton.setTitle("进入应用", for: .normal)
        enterMainButton.alpha = 0
        // 视频播放器的视图 自定义的控件可以添加在其上contentOverlayView
        self.view.addSubview(enterMainButton)
        enterMainButton.addTarget(self, action: #selector(self.enterMainAction), for: .touchUpInside)
        UIView.animate(withDuration: 1.5, animations: {() -> Void in
            enterMainButton.alpha = 1.0
        })
    }
    
    @objc func enterMainAction(_ btn: UIButton) {
        UIView.animate(withDuration: 0.8) { 
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
//        let user = SaveTools.mg_UnArchiver(path: MGUserPath) as? User   // 获取用户数据
//        MGKeyWindow?.rootViewController =  (user == nil) ? UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() : MainTabBarViewController()
        
    }
}
