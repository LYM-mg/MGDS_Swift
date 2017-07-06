//
//  RoomViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
    // MARK: - 属性
    fileprivate var player : IJKFFMoviePlayerController?
    fileprivate lazy var roomVM : RoomViewModel = RoomViewModel()
    fileprivate lazy var bgImageView: UIImageView = UIImageView(frame: MGScreenBounds)
    // MARK: 对外提供控件属性
    fileprivate var anchor: MoreModel?
    
    
    // MARK: - life cycle
    convenience init(anchor: MoreModel) {
        self.init()
        self.anchor = anchor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpMainView()
        loadRoomInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.shutdown()
    }
    
    deinit {
        debugPrint("RoomViewController--deinit")
    }

}

// MARK:- 设置UI界面内容
extension RoomViewController {
    fileprivate func setUpMainView(){
        setUpBlurView()
        
        setUpOtherView()
    }
    
    fileprivate func setUpBlurView(){
        view.addSubview(bgImageView)
        bgImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
        bgImageView.kf.setImage(with: URL(string: anchor!.pic51), placeholder:  UIImage(named: "10"))
    }
    
    fileprivate func setUpOtherView() {
        let popBtn = UIButton(imageName: "goback", target: self, action: #selector(popClick(sender:)))
        let likeBtn = UIButton(imageName: "like", target: self, action: #selector(heartClick(sender:)))
        view.addSubview(popBtn)
        view.addSubview(likeBtn)
        
        popBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        likeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(popBtn)
            make.bottom.right.equalTo(view).offset(-20)
        }
        view.bringSubview(toFront: popBtn)
        view.bringSubview(toFront: likeBtn)
    }
    
    
    @objc fileprivate func popClick(sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    @objc fileprivate func heartClick(sender: UIButton) {
        //爱心大小
        let heart = DMHeartFlyView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        //爱心的中心位置
        heart.center = CGPoint(x: sender.frame.origin.x, y: sender.frame.origin.y)
        
        view.addSubview(heart)
        heart.animate(in: view)
        
        
        //爱心按钮的 大小变化动画
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values   = [1.0, 0.7, 0.5, 0.3, 0.5, 0.7, 1.0, 1.2, 1.4, 1.2, 1.0]
        btnAnime.keyTimes = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        btnAnime.duration = 0.3
        sender.layer.add(btnAnime, forKey: "SHOW")
    }
}

// MARK:- 加载房间信息
extension RoomViewController {
    fileprivate func loadRoomInfo() {
        if let roomid = anchor?.roomid, let uid = anchor?.uid {
            print(roomid, uid)
            roomVM.loadLiveURL(roomid, uid, { _ in 
                self.setupDisplayView()
            })
        }
    }
    
    fileprivate func setupDisplayView() {
        // 0.关闭log
        IJKFFMoviePlayerController.setLogReport(false)
        
        // 1.初始化播放器
        let url = URL(string: roomVM.liveURL)
        player = IJKFFMoviePlayerController(contentURL: url, with: nil)
        
        // 2.设置播放器View的位置和尺寸 
        player?.view.frame = view.bounds
        if anchor?.push == 1 {
            player?.view.frame = CGRect(x: 0, y: 150, width: MGScreenW, height: MGScreenW*3/4)
        }
        player?.view.frame = view.bounds
        player?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player?.scalingMode = .aspectFit
        
        // 3.将view添加到控制器的view中
        bgImageView.insertSubview(player!.view, at: 1)
        
        // 4.准备播放
        DispatchQueue.global().async {
            self.player?.prepareToPlay()
            self.player?.play()
        }
    }
}
