//
//  MGPlayerViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGPlayerViewController: UIViewController {
    // MARK: - 属性
    // MARK: 自定义
    var live : MGHotModel!
    fileprivate var ijplayer: IJKMediaPlayback?
    fileprivate var playerView: UIView?
    
    // MARK: SB拖拽属性
    @IBOutlet weak var giftBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imgBackground: UIImageView!
    
    // MARK: - 生命周期
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // 1.默认模糊主播头像背景
        setBg()
        
        // 2.准备播放器
        setPlayerView()
        
        // 3.把按钮提升到view最前面
//        bringBtnTofront()
    }
    
    //view加载完成后,开始播放视频
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 2.准备播放器
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if self.ijplayer != nil {
            if !(self.ijplayer!.isPlaying()) {
                ijplayer?.prepareToPlay()
            } else {
                ijplayer?.prepareToPlay()
            }
        }else {  // ijk为空时 
            setPlayerView()
            ijplayer?.prepareToPlay()
        }
        bringBtnTofront()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if ((ijplayer) != nil) {
            ijplayer!.shutdown()
            ijplayer!.view.removeFromSuperview()
            ijplayer = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - setPlayerView
extension MGPlayerViewController  {
    func setPlayerView()  {
        //初始化一个空白容器view
        self.playerView = UIView(frame: MGScreenBounds)
        view.addSubview(self.playerView!)
        
        
        //初始化IJ播放器的控制器和view
        ijplayer = IJKFFMoviePlayerController(contentURLString: live.flv!, with: nil)
        let pv = ijplayer!.view!
        
        
        //将播放器view自适应后,加入容器
        pv.frame = playerView!.bounds
        pv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView!.insertSubview(pv, at: 1)
        ijplayer!.scalingMode = .aspectFill
    }
}

// MARK: - 初始化的一些方法
extension MGPlayerViewController {
    
    func setBg()  {
        //头像
        let imgUrl = URL(string: live.bigpic!)
        imgBackground.kf.setImage(with: imgUrl, placeholder:  UIImage(named: "10"))
        
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = imgBackground.bounds
        imgBackground.addSubview(effectView)
    }
    
    
    func bringBtnTofront()  {
        self.view.bringSubview(toFront: likeBtn)
        self.view.bringSubview(toFront: backBtn)
        self.view.bringSubview(toFront: giftBtn)
    }
}

// MARK: - Action
extension MGPlayerViewController {
    // 点击礼物🎁
    @IBAction func giftBtnTap(_ sender: UIButton) {
        sender.isEnabled = false
        
        let carImageView = UIImageView(image: #imageLiteral(resourceName: "porsche"))
        let duration = 3.0
        carImageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.addSubview(carImageView)
        
        let widthP918:CGFloat = 240
        let heightP918:CGFloat = 120
        
        UIView.animate(withDuration: duration) {
            carImageView.frame =
                CGRect(x: self.view.center.x - widthP918/2, y: self.view.center.y - heightP918/2, width: widthP918, height: heightP918)
        }
        
        //主线程延时一个完整动画后,再让礼物图片逐渐透明,完全透明后从父视图移除
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: duration, animations: {
                    carImageView.alpha = 0
                }, completion: { (completed) in
                    carImageView.removeFromSuperview()
            })
        }
        
        // 烟花 https://github.com/yagamis/emmitParticles
        let layerFw = CAEmitterLayer()
        view.layer.addSublayer(layerFw)
        emmitParticles(from: sender.center, emitter: layerFw, in: view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2) {
            layerFw.removeFromSuperlayer()
            sender.isEnabled = true
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
//        ijplayer.shutdown()
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func like(_ sender: UIButton) {
        //爱心大小
        let heart = DMHeartFlyView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        //爱心的中心位置
        heart.center = CGPoint(x: likeBtn.frame.origin.x, y: likeBtn.frame.origin.y)
        
        view.addSubview(heart)
        heart.animate(in: view)
        
        
        //爱心按钮的 大小变化动画
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values   = [1.0, 0.7, 0.5, 0.3, 0.5, 0.7, 1.0, 1.2, 1.4, 1.2, 1.0]
        btnAnime.keyTimes = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        btnAnime.duration = 0.2
        sender.layer.add(btnAnime, forKey: "SHOW")
        
    }
}

extension MGPlayerViewController {
    // 向上拖动弹出视图的操作
    // MARK: - 3DTouch Sliding Action
    override var previewActionItems: [UIPreviewActionItem] {
        let shareAction = UIPreviewAction(title: "分享", style: .default) { (action, controller) in
            print("点击了分享按钮!") // "http://www.jianshu.com/u/57b58a39b70e"
            
            let image = self.imgBackground.image
            let str = self.live.myname!
            let url = NSURL(string: self.live.flv)
            let items:[Any] = [image, str, url!]
            
            let activity = UIActivityViewController(activityItems: items, applicationActivities: [UIActivity()])

            // .copyToPasteboard,.copyToPasteboard,.message,.print,UIActivityType.airDrop,,.postToWeibo,.postToVimeo,.postToTencentWeibo,.mail,.assignToContact,.postToFacebook,.openInIBooks,.postToTwitter
            // 不出现在活动项目
            if #available(iOS 9.0, *) {
                activity.excludedActivityTypes = [.addToReadingList]
            }
            let popver: UIPopoverPresentationController? = activity.popoverPresentationController
            if (popver != nil) {
                popver!.permittedArrowDirections = UIPopoverArrowDirection.left
            }
            MGKeyWindow?.rootViewController?.present(activity, animated: true, completion: nil)
            
            activity.completionWithItemsHandler = { (type, completed, result, err)  in
                if completed {
                    MGKeyWindow?.rootViewController?.showHint(hint: "成功")
                }
                activity.completionWithItemsHandler = nil
            }
        }
        let favAction = UIPreviewAction(title: "收藏", style: .default) { (action, controller) in
            MGKeyWindow?.rootViewController?.showHint(hint: "收藏!")
            MGNotificationCenter.post(name: NSNotification.Name(KSelectedFavouriteAnchorNotification), object: nil, userInfo: ["model": self.live])
        }
        return [shareAction,favAction]
    }
}

