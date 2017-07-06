//
//  HomeViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit


private let kTitlesViewH : CGFloat = 40

class HomeViewController: UIViewController {
    // MARK: - lazy
    fileprivate lazy var homeTitlesView: HomeTitlesView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: MGNavHeight, width: MGScreenW, height: kTitlesViewH)
        let titles = ["推荐","精华","热门","斗鱼","娱乐","逗视"] //
        let tsView = HomeTitlesView(frame: titleFrame, titles: titles)
        tsView.deledate = self
        return tsView
    }()
    fileprivate lazy var homeContentView: HomeContentView = { [weak self] in
        // 1.确定内容的frame
        let contentH = MGScreenH - MGNavHeight - kTitlesViewH - MGTabBarHeight
        let contentFrame = CGRect(x: 0, y: MGNavHeight+kTitlesViewH, width: MGScreenW, height: contentH)
        
        // 2.确定所有的子控制器
        var childVcs = [UIViewController]()
        
        // 2.2映客直播
        let livekySearchVC = UIStoryboard(name: "Liveky", bundle: nil).instantiateInitialViewController() as! LiveTableViewController
        livekySearchVC.topicType = LivekyTopicType.search
        childVcs.append(livekySearchVC)
        
        // 2.3喵播
        let hotVC = MGHotViewController()
        childVcs.append(hotVC)
        let newVC = MGNewViewController()
        childVcs.append(newVC)
        
        // 2.4斗鱼
        childVcs.append(AnchorViewController())
        
        // 2.5腾讯
        let tencentVC = UIStoryboard(name: "Tencent", bundle: nil).instantiateInitialViewController() as! MGTencentNewsViewController
//        let sinaNewsVC = UIStoryboard(name: "Tencent", bundle: nil).instantiateViewController(withIdentifier: "KTrunToSinaNewsVC") as! MGSinaNewsViewController
        childVcs.append(tencentVC)
        
        // 2.6映客直播
        let livekyTopVC = UIStoryboard(name: "Liveky", bundle: nil).instantiateInitialViewController() as! LiveTableViewController
        livekyTopVC.topicType = .top
        childVcs.append(livekyTopVC)
        
        let contentView = HomeContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.创建UI
        setUpMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - 初始化UI
extension HomeViewController {
    fileprivate func setUpMainView() {
        setUpNavgationBar()
        view.addSubview(homeTitlesView)
        view.addSubview(homeContentView)
    }
    fileprivate func setUpNavgationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "更多", style: .plain, target: self, action: #selector(moreClick))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "time.png"),  style: .plain, target: self, action: #selector(leftClick))
    }
    @objc fileprivate func moreClick() {
        self.show(MoreViewController(), sender: nil)
    }
    @objc fileprivate func leftClick() {
        self.show(ClockViewController(), sender: nil)
    }
}

// MARK:- 遵守 HomeTitlesViewDelegate 协议
extension HomeViewController : HomeTitlesViewDelegate {
    func HomeTitlesViewDidSetlected(homeTitlesView: HomeTitlesView, selectedIndex: Int) {
        homeContentView.setCurrentIndex(currentIndex: selectedIndex)
    }
}


// MARK:- 遵守 HomeContentViewDelegate 协议
extension HomeViewController : HomeContentViewDelegate {
    func HomeContentViewDidScroll(contentView: HomeContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        homeTitlesView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


