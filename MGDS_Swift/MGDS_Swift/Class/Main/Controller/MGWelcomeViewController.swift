//
//  MGWelcomeViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/4/28.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class MGWelcomeViewController: UIViewController {
    // MARK: - 属性
    fileprivate var player: MPMoviePlayerController? = nil
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
        debugPrint("MGWelcomeViewController--deinit")
    }
}

// MARK: - setUpUI
extension MGWelcomeViewController {
    fileprivate func setUpUI() {
        setUpWelcomeVideoView()
        setUpWelcomeBtn()
        // 播放结束通知
        MGNotificationCenter.addObserver(self, selector: #selector(self.enterMainAction(_:)), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: player)
    }
    
    fileprivate func setUpWelcomeVideoView() {
        let url = URL(fileURLWithPath: self.urlStr!)
        guard let player = MPMoviePlayerController(contentURL: url) else { return }
        self.player = player
        self.view.addSubview(player.view)
        player.shouldAutoplay = true
        player.scalingMode = MPMovieScalingMode.aspectFill
        player.controlStyle = MPMovieControlStyle.none
        player.repeatMode = MPMovieRepeatMode.none
        player.view.frame = self.view.bounds
        player.view.alpha = 0.0
        
        UIView.animate(withDuration: 1.0) {
            player.view.alpha = 1.0
            player.prepareToPlay()
        }
    }
    
    fileprivate func setUpWelcomeBtn() {
        // 进入按钮
        let enterMainButton = UIButton()
        enterMainButton.frame = CGRect(x: 24, y: player!.view.bounds.size.height - 32 - 48, width: UIScreen.main.bounds.size.width - 48, height: 48)
        enterMainButton.layer.borderWidth = 1
        enterMainButton.layer.cornerRadius = 24
        enterMainButton.layer.borderColor = UIColor.white.cgColor
        enterMainButton.setTitle("进入应用", for: .normal)
        enterMainButton.alpha = 0
        player?.view.addSubview(enterMainButton)
        enterMainButton.addTarget(self, action: #selector(self.enterMainAction), for: .touchUpInside)
        UIView.animate(withDuration: 3.0, animations: {() -> Void in
            enterMainButton.alpha = 1.0
        })
    }
    
    
    @objc func enterMainAction(_ btn: UIButton) {
        player = nil
        let user = SaveTools.mg_UnArchiver(path: MGUserPath) as? User   // 获取用户数据
        MGKeyWindow?.rootViewController =  (user == nil) ? UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() : MainTabBarViewController()
    }
}


